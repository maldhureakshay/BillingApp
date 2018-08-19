class DRecord{

  String customerName;
  String orderNo;
  String mobileNo;
  String totalAmount;
  String paidAmount;
  int date;
  
  DRecord(this.customerName, this.orderNo,this.mobileNo,this.totalAmount,this.paidAmount, this.date);
  
   DRecord.fromMap(Map map) {
    customerName = map[customerName];
    orderNo = map[orderNo];
    mobileNo = map[mobileNo];
    totalAmount = map[totalAmount];
    paidAmount = map[paidAmount];
    date       = map[date];
  }
  
}