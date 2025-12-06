import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up with Email and Password
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Get current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Step 3: Update display name first (this is quick)
        try {
          await user.updateDisplayName(name);
        } catch (e) {
          print('Update display name error: $e');
        }

        // Step 4: Store in Firestore (don't await - do it in background)
        _saveUserToFirestore(user.uid, name, email);

        return {
          'success': true,
          'message': 'Account created successfully!',
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to create account.',
        };
      }
    } catch (e) {
      print('Sign Up Error: $e');

      // Check if user was actually created despite error
      if (_auth.currentUser != null) {
        return {
          'success': true,
          'message': 'Account created successfully!',
          'user': _auth.currentUser,
        };
      }

      String message = _handleAuthError(e);
      return {
        'success': false,
        'message': message,
      };
    }
  }

  // Save user to Firestore in background (non-blocking)
  void _saveUserToFirestore(String uid, String name, String email) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImage': '',
      });
      print('User data saved to Firestore successfully');
    } catch (e) {
      print('Firestore save error: $e');
    }
  }

  // Sign In with Email and Password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // First, sign out any existing user to ensure fresh login
      if (_auth.currentUser != null) {
        await _auth.signOut();
      }

      // Attempt to sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if we got a valid user
      if (userCredential.user != null) {
        return {
          'success': true,
          'message': 'Signed in successfully!',
          'user': userCredential.user,
        };
      } else {
        return {
          'success': false,
          'message': 'Sign in failed. Please try again.',
        };
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String message = _handleAuthError(e);
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      print('Sign In Error: $e');
      String message = _handleAuthError(e);
      return {
        'success': false,
        'message': message,
      };
    }
  }
  // Handle all Firebase Auth errors
  String _handleAuthError(dynamic e) {
    String errorMessage = e.toString().toLowerCase();

    if (errorMessage.contains('user-not-found')) {
      return 'No user found with this email.';
    } else if (errorMessage.contains('wrong-password')) {
      return 'Wrong password provided.';
    } else if (errorMessage.contains('invalid-credential')) {
      return 'Invalid email or password.';
    } else if (errorMessage.contains('invalid-email')) {
      return 'The email address is not valid.';
    } else if (errorMessage.contains('user-disabled')) {
      return 'This user has been disabled.';
    } else if (errorMessage.contains('email-already-in-use')) {
      return 'An account already exists with this email.';
    } else if (errorMessage.contains('weak-password')) {
      return 'The password is too weak.';
    } else if (errorMessage.contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorMessage.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    }

    return 'An error occurred. Please try again.';
  }

  // Sign In with Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return {
          'success': false,
          'message': 'Google sign in cancelled.',
        };
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      User? user = _auth.currentUser;

      if (user != null) {
        // Save to Firestore in background
        _saveGoogleUserToFirestore(user);

        return {
          'success': true,
          'message': 'Signed in with Google successfully!',
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': 'Google sign in failed.',
        };
      }
    } catch (e) {
      print('Google Sign In Error: $e');

      if (_auth.currentUser != null) {
        return {
          'success': true,
          'message': 'Signed in with Google successfully!',
          'user': _auth.currentUser,
        };
      }

      return {
        'success': false,
        'message': 'Google sign in failed.',
      };
    }
  }

  // Save Google user to Firestore in background
  void _saveGoogleUserToFirestore(User user) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? 'User',
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'profileImage': user.photoURL ?? '',
        });
      }
    } catch (e) {
      print('Firestore Google user save error: $e');
    }
  }

  // Password Reset
  Future<Map<String, dynamic>> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent!',
      };
    } catch (e) {
      print('Reset Password Error: $e');
      return {
        'success': false,
        'message': 'Failed to send reset email.',
      };
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      print('Google Sign Out Error: $e');
    }
    await _auth.signOut();
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Get User Data Error: $e');
      return null;
    }
  }

  // Update user data
  Future<bool> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      return true;
    } catch (e) {
      print('Update User Data Error: $e');
      return false;
    }
  }
}