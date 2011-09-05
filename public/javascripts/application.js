$(function(){

  $('.date').each(function(el){
    var date = Date.parseRFC3339(el.html());
    if (date !== null) el.html(date.toString("d/M/yyyy HH:mm"));
  });

    $('input[id^=booking_date]').each(function(el){
        var min_date = new Date();
        var max_date = new Date();
        max_date.setMonth(max_date.getMonth() + 1)
        var cal = new Calendar({
            format: "ISO",
            minDate: min_date,
            maxDate: max_date,
            numberOfMonths: 1,
            timePeriod: 15,
            showTime: true,
            update: el
        });
        cal.on('change', function(){
            console.log(this.getDate().toRFC3339UTCString());
            el.set('value', this.getDate().toRFC3339UTCString());
        });
        cal.setDate(new Date.parse(el.get('value')));

        if (el.parent().parent().get('id') == "booking_widget"){
            cal.assignTo(el.parent());
        } else {
            el.set('type','hidden');
            cal.insertTo(el.parent());
        }
    });
});
