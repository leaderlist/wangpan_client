String getFileType(String? filePath) {
  return filePath?.split('.').last ?? '';
}