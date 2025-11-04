Chart.defaults.global.defaultFontFamily =
  'Nunito', '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#858796';

function number_format(number, decimals, dec_point, thousands_sep) {
  number = (number + '').replace(',', '').replace(' ', '');
  var n = !isFinite(+number) ? 0 : +number,
    prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
    sep = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
    dec = (typeof dec_point === 'undefined') ? '.' : dec_point,
    s = '',
    toFixedFix = function (n, prec) {
      var k = Math.pow(10, prec);
      return '' + Math.round(n * k) / k;
    };
  s = (prec ? toFixedFix(n, prec) : '' + Math.round(n)).split('.');
  if (s[0].length > 3) s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep);
  if ((s[1] || '').length < prec) {
    s[1] = s[1] || '';
    s[1] += new Array(prec - s[1].length + 1).join('0');
  }
  return s.join(dec);
}

// 차트 렌더링 함수
const ctx = document.getElementById('myAreaChart').getContext('2d');
let chart;
function renderInquiryChart(year) {
  fetch(`/admin/inquiry-stats/year?year=${year}`)
    .then(res => res.json())
    .then(data => {
      const labels = data.map(item => `${parseInt(item.month)}월`);
      const counts = data.map(item => item.count);

      const titleEl = document.getElementById('chartTitle');
      if (titleEl) titleEl.textContent = `${year}년 월별 문의 현황`;

      if (chart) chart.destroy();

      chart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
            label: `${year}년 월별 문의 수`,
            lineTension: 0.3,
            backgroundColor: "rgba(78, 115, 223, 0.05)",
            borderColor: "rgba(78, 115, 223, 1)",
            pointRadius: 3,
            pointBackgroundColor: "rgba(78, 115, 223, 1)",
            pointBorderColor: "rgba(78, 115, 223, 1)",
            pointHoverRadius: 3,
            pointHoverBackgroundColor: "rgba(78, 115, 223, 1)",
            pointHoverBorderColor: "rgba(78, 115, 223, 1)",
            pointHitRadius: 10,
            pointBorderWidth: 2,
            data: counts,
          }],
        },
        options: {
          maintainAspectRatio: false,
          layout: {
            padding: { left: 10, right: 25, top: 25, bottom: 0 }
          },
          scales: {
            xAxes: [{
              gridLines: { display: false, drawBorder: false },
              ticks: { maxTicksLimit: 12 }
            }],
            yAxes: [{
              ticks: {
                beginAtZero: true,
                maxTicksLimit: 4,
                padding: 10,
                callback: function (value) {
                  return number_format(value) + '건';
                }
              },
              gridLines: {
                color: "rgb(234, 236, 244)",
                zeroLineColor: "rgb(234, 236, 244)",
                drawBorder: false,
                borderDash: [2],
                zeroLineBorderDash: [2]
              }
            }],
          },
          legend: { display: false },
          tooltips: {
            backgroundColor: "rgb(255,255,255)",
            bodyFontColor: "#858796",
            titleMarginBottom: 10,
            titleFontColor: '#6e707e',
            titleFontSize: 14,
            borderColor: '#dddfeb',
            borderWidth: 1,
            xPadding: 15,
            yPadding: 15,
            displayColors: false,
            intersect: false,
            mode: 'index',
            caretPadding: 10,
            callbacks: {
              label: function (tooltipItem, chart) {
                var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label || '';
                return datasetLabel + ': ' + number_format(tooltipItem.yLabel) + '건';
              }
            }
          }
        }
      });
    })
    .catch(err => console.error('차트 데이터 로드 실패:', err)); // 에러 핸들링
}


// 연도 선택 이벤트
document.addEventListener('DOMContentLoaded', () => {
  const yearSelect = document.getElementById('yearSelect');
  if (!yearSelect) return;

  yearSelect.addEventListener('change', e => renderInquiryChart(e.target.value));
  renderInquiryChart(yearSelect.value); // 초기 로드
});
