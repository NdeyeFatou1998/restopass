import { AfterViewInit, Component, OnInit } from '@angular/core';
import { ParamsService } from 'app/services/params.service';
import * as Chartist from 'chartist';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit, AfterViewInit {
  statistics: any;
  isLoad: boolean = true;
  filtersLoaded: Promise<boolean>;
  dataDailySalesChart: any;
  optionsDailySalesChart: {
    lineSmooth: Function; low: number; high: number; // creative tim: we recommend you to set the high sa the biggest value + something for a better look
    chartPadding: { top: number; right: number; bottom: number; left: number; };
  };
  dataCompletedTasksChart: { labels: string[]; series: number[][]; };
  optionsCompletedTasksChart: {
    lineSmooth: Function; low: number; high: number; // creative tim: we recommend you to set the high sa the biggest value + something for a better look
    chartPadding: { top: number; right: number; bottom: number; left: number; };
  };
  datawebsiteViewsChart: { labels: string[]; series: number[][]; };
  optionswebsiteViewsChart: any;
  constructor(private paramsService
    : ParamsService) { }

  ngAfterViewInit() {
    if (!this.isLoad) {
    }
  }

  ngOnInit() {
    this._init();
    this.getStatistics();
  }

  startAnimationForLineChart(chart) {
    let seq: any, delays: any, durations: any;
    seq = 0;
    delays = 80;
    durations = 500;

    chart.on('draw', function (data) {
      if (data.type === 'line' || data.type === 'area') {
        data.element.animate({
          d: {
            begin: 600,
            dur: 700,
            from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify(),
            to: data.path.clone().stringify(),
            easing: Chartist.Svg.Easing.easeOutQuint
          }
        });
      } else if (data.type === 'point') {
        seq++;
        data.element.animate({
          opacity: {
            begin: seq * delays,
            dur: durations,
            from: 0,
            to: 1,
            easing: 'ease'
          }
        });
      }
    });

    seq = 0;
  };

  startAnimationForBarChart(chart) {
    let seq2: any, delays2: any, durations2: any;

    seq2 = 0;
    delays2 = 80;
    durations2 = 500;
    chart.on('draw', function (data) {
      if (data.type === 'bar') {
        seq2++;
        data.element.animate({
          opacity: {
            begin: seq2 * delays2,
            dur: durations2,
            from: 0,
            to: 1,
            easing: 'ease'
          }
        });
      }
    });

    seq2 = 0;
  };

  getStatistics() {
    this.isLoad = true;
    this.paramsService.statistics()
      .subscribe({
        next: response => {
          this.statistics = response;
          console.log("STAT", this.statistics);
          this.isLoad = false
          this.resetCharts(response);
        },
        error: errors => {
          this.isLoad = false
          this.filtersLoaded = Promise.resolve(true);
        }
      });
  }

  resetCharts(response: any) {

    this.dataDailySalesChart = {
      labels: ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      series: [
        response?.prd_y.p
      ]
    };

    this.optionsDailySalesChart = {
      lineSmooth: Chartist.Interpolation.cardinal({
        tension: 0
      }),
      low: 0,
      high: this.maxValue(response?.prd_y.p), // creative tim: we recommend you to set the high sa the biggest value + something for a better look
      chartPadding: { top: 0, right: 0, bottom: 0, left: 0 },
    }

    var dailySalesChart = new Chartist.Line('#dailySalesChart', this.dataDailySalesChart, this.optionsDailySalesChart);

    this.startAnimationForLineChart(dailySalesChart);

    /* ----------==========     Completed Tasks Chart initialization    ==========---------- */

    this.dataCompletedTasksChart = {
      labels: ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      series: [
        response?.prd_y.r
      ]
    };

    this.optionsCompletedTasksChart = {
      lineSmooth: Chartist.Interpolation.cardinal({
        tension: 0
      }),
      low: 0,
      high: this.maxValue(response?.prd_y.r), // creative tim: we recommend you to set the high sa the biggest value + something for a better look
      chartPadding: { top: 0, right: 0, bottom: 0, left: 0 }
    }

    var completedTasksChart = new Chartist.Line('#completedTasksChart', this.dataCompletedTasksChart, this.optionsCompletedTasksChart);

    // start animation for the Completed Tasks Chart - Line Chart
    this.startAnimationForLineChart(completedTasksChart);

    /* ----------==========     Emails Subscription Chart initialization    ==========---------- */

    this.datawebsiteViewsChart = {
      labels: ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      series: [
        response?.prd_y.d
      ]
    };

    this.optionswebsiteViewsChart = {
      lineSmooth: Chartist.Interpolation.cardinal({
        tension: 0
      }),
      low: 0,
      high: this.maxValue(response?.prd_y.d),
      chartPadding: { top: 0, right: 5, bottom: 0, left: 0 }
    };
    
    var websiteViewsChart = new Chartist.Bar('#websiteViewsChart', this.datawebsiteViewsChart, this.optionswebsiteViewsChart);
    //start animation for the Emails Subscription Chart
    this.startAnimationForBarChart(websiteViewsChart);
  }

  maxValue(p: []): number {
    let r = 0;
    p.forEach(e => {
      r += e;
    });
    return r;
  }

  _init() {
    /* ----------==========     Daily Sales Chart initialization For Documentation    ==========---------- */

    this.dataDailySalesChart = {
      labels: ['J', 'F', 'M', 'A', 'M', 'J', 'JL', 'A', 'S', 'O', 'N', 'D'],
      series: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]
    };

    var dailySalesChart = new Chartist.Line('#dailySalesChart', this.dataDailySalesChart);

    this.startAnimationForLineChart(dailySalesChart);


    /* ----------==========     Completed Tasks Chart initialization    ==========---------- */

    this.dataCompletedTasksChart = {
      labels: ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      series: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]
    };

    var completedTasksChart = new Chartist.Line('#completedTasksChart', this.dataCompletedTasksChart,);

    // start animation for the Completed Tasks Chart - Line Chart
    this.startAnimationForLineChart(completedTasksChart);



    /* ----------==========     Emails Subscription Chart initialization    ==========---------- */

    this.datawebsiteViewsChart = {
      labels: ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
      series: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]
    };

    var websiteViewsChart = new Chartist.Line('#websiteViewsChart', this.datawebsiteViewsChart,);

    //start animation for the Emails Subscription Chart
    this.startAnimationForBarChart(websiteViewsChart);

  }

}
