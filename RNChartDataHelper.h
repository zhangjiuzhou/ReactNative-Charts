//
//  RNChartDataHelper.h
//  RNCharts
//
//  Created by 张九州 on 2017/6/22.
//

#import <Foundation/Foundation.h>
#import <Charts/Charts.h>

@interface RNChartDataHelper : NSObject

+ (LineChartDataSet *)lineDataSetWithDict:(NSDictionary *)dict;
+ (BarChartDataSet *)barDataSetWithDict:(NSDictionary *)dict;
+ (PieChartDataSet *)pieDataSetWithDict:(NSDictionary *)dict;
+ (CandleChartDataSet *)candleStickDataSetWithDict:(NSDictionary *)dict;

+ (void)updateViewPointOffsets:(BarLineChartViewBase *)chartView withDict:(NSDictionary *)dict;
+ (void)updateChartDescription:(ChartDescription *)chartDescription withDict:(NSDictionary *)dict;
+ (void)updateLegend:(ChartLegend *)legend withDict:(NSDictionary *)dict;
+ (void)updateXAxis:(ChartXAxis *)xAxis withDict:(NSDictionary *)dict;
+ (void)updateXAxis:(ChartXAxis *)xAxis withDict:(NSDictionary *)dict xValues:(NSArray *)xValues;
+ (void)updateYAxis:(ChartYAxis *)yAxis withDict:(NSDictionary *)dict;

+ (ChartMarkerImage *)markerWithDict:(NSDictionary *)dict;

@end

