import 'dart:convert';
import 'dart:io';

import 'package:qm_mlm_flutter/utils/extensions.dart';

class PostKYCDetailsModel {
  final String kyc;
  final DateTime dob;
  final String document;
  final String documentType;
  final String documentNumber;
  final String nameAsPerDocument;

  PostKYCDetailsModel({
    required this.kyc,
    required this.dob,
    required this.documentType,
    required this.document,
    required this.documentNumber,
    required this.nameAsPerDocument,
  });

  Future<Map<String, dynamic>> toJson() async {
    List<int> documentBytes = await File(document).readAsBytes();
    final String documentName =
        "${nameAsPerDocument.split(' ').join('_')}.${document.split('.').last}";

    return {
      'kyc': kyc,
      'document_type': documentType,
      'document_no': documentNumber,
      'document_name': nameAsPerDocument,
      'document_file_name': documentName,
      'document': base64Encode(documentBytes),
      'date_of_birth': dob.getDefaultDateFormat,
    };
  }

  @override
  String toString() {
    return 'PostKYCDetailsModel(kyc: $kyc, dob: $dob, document: $document, documentType: $documentType, documentNumber: $documentNumber, nameAsPerDocument: $nameAsPerDocument)';
  }
}
