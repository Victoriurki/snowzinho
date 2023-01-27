import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAdapter extends InterfaceFirestoreClient {
  final FirebaseFirestore instance;
  FirestoreAdapter({required this.instance});

  @override
  Future<Resource<List<Map<String, dynamic>>, FirestoreErrorType>>
      getCollection({
    required String path,
    int? limit,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = limit != null
          ? await instance.collection(path).limit(limit).get()
          : await instance.collection(path).get();

      if (querySnapshot.docs.isNotEmpty) {
        log('[FIRESETORE_GET_COLLECTION_IS_NOT_EMPTY]');
        final List<Map<String, dynamic>> listMap =
            querySnapshot.docs.map((doc) => doc.data()).toList();
        return Resource(data: listMap);
      } else {
        log('[FIRESETORE_GET_COLLECTION_IS_EMPTY]');
        return Resource(error: FirestoreErrorType.collectionIsEmpty);
      }
    } catch (error) {
      log('[FIRESETORE_GET_COLLECTION_ERROR]: ' + error.toString());
      // rethrow; // TODO
      return Resource(error: FirestoreErrorType.serverError);
    }
  }

  @override
  Future<Resource<Map<String, dynamic>, FirestoreErrorType>> getDocument(
      {required String path}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await instance.doc(path).get();

      if (documentSnapshot.exists) {
        log('[FIRESETORE_GET_DOCUMENT_EXISTS]');
        final Map<String, dynamic> map = documentSnapshot.data()!;

        return Resource(data: map);
      } else {
        log('[FIRESETORE_GET_DOCUMENT_DOES_NOT_EXIST]');
        return Resource(error: FirestoreErrorType.documentDoesNotExist);
      }
    } catch (error) {
      log('[FIRESETORE_GET_DOCUMENT_ERROR]: ' + error.toString());
      // rethrow;  // TODO
      return Resource(error: FirestoreErrorType.serverError);
    }
  }

  @override
  Future<Resource<Map<String, dynamic>, FirestoreErrorType>> addDocument({
    required String path,
    required Map<String, dynamic> object,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> documentSnapshot =
          await instance.collection(path).add(object);

      log('[FIRESETORE_ADD_DOCUMENT_SUCCESS]');
      return Resource(data: object);
    } catch (error) {
      log('[FIRESETORE_ADD_DOCUMENT_ERROR]: ' + error.toString());
      // rethrow; // TODO
      return Resource(error: FirestoreErrorType.serverError);
    }
  }

  @override
  Future<Resource<Map<String, dynamic>, FirestoreErrorType>> setDocument({
    required String path,
    required String documentId,
    required Map<String, dynamic> object,
  }) async {
    try {
      final documentSnapshot =
          await instance.doc(path + '/' + documentId).set(object);

      log('[FIRESETORE_SET_DOCUMENT_SUCCESS]');
      return Resource(data: object);
    } catch (error) {
      log('[FIRESETORE_SET_DOCUMENT_ERROR]: ' + error.toString());
      // rethrow; // TODO
      return Resource(error: FirestoreErrorType.serverError);
    }
  }

  @override
  Future<Resource<String, FirestoreErrorType>> addDocumentAndReturnId({
    required String path,
    required Map<String, dynamic> object,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> documentSnapshot =
          await instance.collection(path).add(object);

      log('[FIRESETORE_ADD_DOCUMENT_SUCCESS]');
      return Resource(data: documentSnapshot.id);
    } catch (error) {
      log('[FIRESETORE_ADD_DOCUMENT_ERROR]: ' + error.toString());
      // rethrow; // TODO
      return Resource(error: FirestoreErrorType.serverError);
    }
  }
}

abstract class InterfaceFirestoreClient {
  Future<Resource<List<Map<String, dynamic>>, FirestoreErrorType>>
      getCollection({
    required String path,
    int? limit,
  });

  Future<Resource<Map<String, dynamic>, FirestoreErrorType>> getDocument({
    required String path,
  });

  Future<Resource<Map<String, dynamic>, FirestoreErrorType>> addDocument({
    required String path,
    required Map<String, dynamic> object,
  });

  Future<Resource<Map<String, dynamic>, FirestoreErrorType>> setDocument({
    required String path,
    required String documentId,
    required Map<String, dynamic> object,
  });

  Future<Resource<String, FirestoreErrorType>> addDocumentAndReturnId({
    required String path,
    required Map<String, dynamic> object,
  });
}

class Resource<T, E> {
  T? data;
  E? error;

  Resource({
    this.data,
    this.error,
  });

  bool get hasData => data != null;

  bool get hasError => error != null;

  bool get isLoading => !hasData && !hasError ? true : false;
}

enum FirestoreErrorType {
  invalidData,
  documentDoesNotExist,
  collectionIsEmpty,
  serverError,
}

enum FirebaseAuthErrorType {
  userDoNotExist,
  userNotFound,
  userNotLoggedIn,
  unexpected,
  emailAlreadyinUse,
}

