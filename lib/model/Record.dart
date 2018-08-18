class DRecord{

  String customerName;
  String orderNo;
  String mobileNo;
  String totalAmount;
  String paidAmount;

  
  DRecord(this.customerName, this.orderNo,this.mobileNo,this.totalAmount,this.paidAmount);
  
   DRecord.fromMap(Map map) {
    customerName = map[customerName];
    orderNo = map[orderNo];
    mobileNo = map[mobileNo];
    totalAmount = map[totalAmount];
    paidAmount = map[paidAmount];
  }
  
}