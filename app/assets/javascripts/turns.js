document.addEventListener("DOMContentLoaded", function(event) {
  var ctx = document.getElementById("nutrients-chart").getContext("2d");
  var myChart = new Chart(ctx, {
    type: "line",
    data: {
      datasets: [
        {
          label: "Nitrogen",
          data: eval(document.getElementById("nitrogen_levels").value),
          borderColor: "red",
          lineTension: 0,
          fill: false
        },
        {
          label: "Phosphorus",
          data: eval(document.getElementById("phosphorus_levels").value),
          borderColor: "green",
          lineTension: 0,
          fill: false
        },
        {
          label: "Potassium",
          data: eval(document.getElementById("potassium_levels").value),
          borderColor: "pink",
          lineTension: 0,
          fill: false
        },
        {
          label: "Water",
          data: eval(document.getElementById("water_levels").value),
          borderColor: "blue",
          lineTension: 0,
          fill: false
        },
        {
          label: "Light",
          data: eval(document.getElementById("light_levels").value),
          borderColor: "yellow",
          lineTension: 0,
          fill: false
        }
      ]
    },
    options: {
      cubicInterpolationMode: "monotone"
    }
  });
});
