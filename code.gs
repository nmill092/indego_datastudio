function goIndego() {

  //   // Call the Numbers API for random math fact
  var response = UrlFetchApp.fetch("https://kiosks.bicycletransit.workers.dev/phl");
  var bike = JSON.parse(response.getContentText());
  var sheet = SpreadsheetApp.getActiveSheet();

 sheet.deleteRows(2,sheet.getLastRow()-1)


  
  function getBikeData() {
    var bikeData = [];
 
    for (var i = 0; i < bike['features'].length; i = i + 1) {
      var now = new Date(); 

      var properties = bike['features'][i]['properties']; 
      var name = properties['name'];
      var bikesAvail = properties['bikesAvailable'];
      var ebikes = properties['electricBikesAvailable']; 
      var totalDocks = properties['totalDocks'];
      var lat = properties['latitude'];
      var long = properties['longitude'];
      var address = properties['addressStreet'];
      var zip = properties['addressZipCode'];
      var id = properties['id']
      var updated_at = now.toLocaleTimeString(); 
      
      bikeData.push([name, bikesAvail, ebikes, totalDocks, lat + ", " + long, address, zip, id, updated_at])
    }
    return bikeData; 
  }

  function writeMultipleRows(data) {
    var lastRow = SpreadsheetApp.getActiveSheet().getLastRow();
    SpreadsheetApp.getActiveSheet().getRange(lastRow + 1, 1, data.length, data[0].length).setValues(data);
  }
  
  writeMultipleRows(getBikeData());

}