//
//  RNLineChart.m
//  RNCharts
//
//  Created by 张九州 on 17/4/26.
//

#import "RNLineChart.h"
#import <React/RCTConvert.h>
#import <Charts/Charts.h>
#import "RNChartDataHelper.h"

@interface RNLineChart : UIView

@property (nonatomic, weak) LineChartView *chartView;

@property (nonatomic, assign) BOOL doubleTapToZoomEnabled;
@property (nonatomic, assign) BOOL scaleEnabled;
@property (nonatomic, assign) BOOL pinchZoom;
@property (nonatomic, strong) NSDictionary *chartDescription;
@property (nonatomic, strong) NSDictionary *legend;
@property (nonatomic, strong) NSArray<NSDictionary *> *dataSets;
@property (nonatomic, strong) NSDictionary *xAxis;
@property (nonatomic, strong) NSDictionary *leftAxis;
@property (nonatomic, strong) NSDictionary *rightAxis;
@property (nonatomic, strong) NSDictionary *viewPortOffsets;
@property (nonatomic, strong) NSDictionary *marker;

@end

@implementation RNLineChart

- (instancetype)init {
    self = [super init];
    if (self) {
        LineChartView *chartView = [LineChartView new];
        [self addSubview:chartView];
        self.chartView = chartView;
    }
    return self;
}

- (void)layoutSubviews {
    self.chartView.frame = self.bounds;
    [super layoutSubviews];
}

- (void)setDoubleTapToZooinEnabled: (BOOL)doubleTapToZoomEnabled {
    self.chartView.doubleTapToZoomEnabled = doubleTapToZoomEnabled;
}

- (void)setMarker:(NSDictionary *)marker {
    ChartMarkerImage *markerView = [RNChartDataHelper markerWithDict:marker];
    markerView.chartView = self.chartView;
    self.chartView.marker = markerView;
}

- (void)setScaleEnabled:(BOOL)scaleEnabled {
    [self.chartView setScaleEnabled:scaleEnabled];
}

- (void)setPinchZoom:(BOOL)pinchZoom {
    self.chartView.pinchZoomEnabled = pinchZoom;
    [self.chartView setScaleEnabled:pinchZoom];
}

- (void)setChartDescription:(NSDictionary *)chartDescription {
    [RNChartDataHelper updateChartDescription:self.chartView.chartDescription withDict:chartDescription];
}

- (void)setLegend:(NSDictionary *)legend {
    [RNChartDataHelper updateLegend:self.chartView.legend withDict:legend];
}

- (void)setDataSets:(NSArray<NSDictionary *> *)dataSets {
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary *dataSetDict in dataSets) {
        LineChartDataSet *dataSet = [RNChartDataHelper lineDataSetWithDict:dataSetDict];
        if (dataSet) {
            [data addObject:dataSet];
        }
    }

    self.chartView.data = [[LineChartData alloc] initWithDataSets:[data copy]];
}

- (void)setXAxis:(NSDictionary *)xAxis {
    [RNChartDataHelper updateXAxis:self.chartView.xAxis withDict:xAxis];
}

- (void)setLeftAxis:(NSDictionary *)leftAxis {
    [RNChartDataHelper updateYAxis:self.chartView.leftAxis withDict:leftAxis];
}

- (void)setRightAxis:(NSDictionary *)rightAxis {
    [RNChartDataHelper updateYAxis:self.chartView.rightAxis withDict:rightAxis];
}

- (void)setViewPortOffsets:(NSDictionary *)viewPortOffssets {
    [RNChartDataHelper updateViewPointOffsets:self.chartView withDict:viewPortOffssets];
}

@end

@implementation RNLineChartManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(doubleTapToZoomEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(scaleEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(pinchZoom, BOOL)
RCT_EXPORT_VIEW_PROPERTY(chartDescription, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(legend, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(dataSets, NSArray *)
RCT_EXPORT_VIEW_PROPERTY(xAxis, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(leftAxis, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(rightAxis, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(viewPortOffsets, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(marker, NSDictionary *)

- (UIView *)view {
    return [[RNLineChart alloc] init];
}

@end
