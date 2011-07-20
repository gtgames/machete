$(function(){
    $('input[id^=booking_date]').each(function(el){
        el.set('type','hidden');
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
        }).insertTo(el.parent());
        cal.on('change', function(){
            console.log(this.getDate().toRFC3339UTCString());
            el.set('value', this.getDate().toRFC3339UTCString());
        });
        cal.setDate(new Date.parse(el.get('value')));
    });
});
