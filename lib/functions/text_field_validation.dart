bool textFieldDoubleValidation(String str, bool canBlank, bool canNegative, bool canZero, bool canDecimal, int maxValue, int minValue, int maxNPreDec, int maxNPostDec){
  bool isValid = true;
  double n;
  try{
    n = double.parse(str);
  }catch (e){
    return false;
  }
  isValid = (str==null||str.contains(',')||str.contains(' '))?(false):(isValid&&true);
  isValid = (!canBlank&&str=='')?(false):(isValid&&true);
  isValid = (!canNegative&&str.contains('-'))?(false):(isValid&&true);
  isValid = (!canDecimal&&str.contains('.'))?(false):(isValid&&true);
  isValid = (!canZero&&n==0)?(false):(isValid&&true);
  isValid = (n>maxValue||n<minValue)?(false):(isValid&&true);
  isValid = (str[0]=='0'&&str.length>1&&!str.contains('.'))?(false):(isValid&&true);
  if(str.contains('.')){
    isValid = (str.split('.').length>2)?(false):(isValid&&true);
    isValid = (str.split('.')[0].length>maxNPreDec||str.split('.')[1].length>maxNPostDec)?(false):(isValid&&true);
  }
  return isValid;
}