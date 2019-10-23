function onClickHandler(date, nb) {
  var jumpTo = ['day', date.getMonth() + 1, date.getDate()].join('-')
  window.location.hash = jumpTo
}

window.addEventListener('DOMContentLoaded', function () {
  var cal = new CalHeatMap();
  cal.init({
    domain: 'month',
    subDomain: 'x_day',
    subDomainTextFormat: "%d",
    range: 3,
    cellSize: 35,
    verticalOrientation: true,
    data: "/api/test/v1/counts",
    // 草の濃さのしきい値
    legend: [2, 3, 4, 5],
    legendVerticalPosition: "top",
    itemName: ['event', 'events'],
    label: {
      position: "top"
    },
    onClick: onClickHandler
  });
})


