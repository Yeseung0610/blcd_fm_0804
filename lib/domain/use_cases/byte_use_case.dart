class ByteUseCase {

  int calculateChecksum(List<int> data) {
    int checksum = 0;
    for (int byte in data) {
      checksum ^= byte;
    }
    checksum |= 0x80;
    return checksum;
  }
}