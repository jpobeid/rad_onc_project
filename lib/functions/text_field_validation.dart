bool textFieldDoubleValidation(
    {required String strN,
    required bool allowBlank,
    required bool allowNegative,
    required bool allowZero,
    required bool allowDecimal,
    required double maxValue,
    required double minValue,
    required int maxDigitsPreDecimal,
    required int maxDigitsPostDecimal}) {
  bool isValid = true;
  double n;
  try {
    n = double.parse(strN);
  } catch (e) {
    return false;
  }
  isValid =
      (strN.contains(',') || strN.contains(' ')) ? (false) : (isValid && true);
  isValid = (!allowBlank && strN == '') ? (false) : (isValid && true);
  isValid =
      (!allowNegative && strN.contains('-')) ? (false) : (isValid && true);
  isValid = (!allowZero && n == 0) ? (false) : (isValid && true);
  isValid = (!allowDecimal && strN.contains('.')) ? (false) : (isValid && true);
  isValid = (n > maxValue || n < minValue) ? (false) : (isValid && true);
  isValid = (strN[0] == '0' && strN.length > 1 && !strN.contains('.'))
      ? (false)
      : (isValid && true);
  if (strN.contains('.')) {
    isValid = (strN.split('.').length > 2) ? (false) : (isValid && true);
    isValid = (strN.split('.')[0].length > maxDigitsPreDecimal ||
            strN.split('.')[1].length > maxDigitsPostDecimal)
        ? (false)
        : (isValid && true);
  }
  return isValid;
}
