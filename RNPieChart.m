//
//  RNPieChart.m
//  RNCharts
//
//  Created by 张九州 on 17/5/11.
//

#import "RNPieChart.h"
#import <React/RCTConvert.h>
#import <Charts/Charts.h>
#import "RNChartDataHelper.h"

@interface RNPieChart : UIView

@property (nonatomic, weak) PieChartView *chartView;

@property (nonatomic, strong) NSDictionary *chartDescription;
@property (nonatomic, strong) NSDictionary *legend;
@property (nonatomic, strong) NSNumber *holeColor;
@property (nonatomic, strong) NSNumber *drawHole;
@property (nonatomic, strong) NSNumber *holeRadiusPercent;
@property (nonatomic, strong) NSNumber *transparentCircleRadiusPercent;
@property (nonatomic, strong) NSNumber *rotationEnabled;
@property (nonatomic, strong) NSArray<NSDictionary *> *dataSets;

@end

@implementation RNPieChart

- (instancetype)init {
    self = [super init];
    if (self) {
        PieChartView *chartView = [PieChartView new];
        [self addSubview:chartView];
        self.chartView = chartView;
    }
    return self;
}

- (void)layoutSubviews {
    self.chartView.frame = self.bounds;
    [super layoutSubviews];
}

- (void)setChartDescription:(NSDictionary *)chartDescription {
    [RNChartDataHelper updateChartDescription:self.chartView.chartDescription withDict:chartDescription];
}

- (void)setLegend:(NSDictionary *)legend {
    [RNChartDataHelper updateLegend:self.chartView.legend withDict:legend];
}

- (void)setHoleColor:(NSNumber *)holeColor {
    self.chartView.holeColor = [RCTConvert UIColor:holeColor];
}

- (void)setDrawHole:(NSNumber *)drawHole {
    self.chartView.drawHoleEnabled = [RCTConvert BOOL:drawHole];
}

- (void)setHoleRadiusPercent:(NSNumber *)holeRadiusPercent {
    self.chartView.holeRadiusPercent = [RCTConvert float:holeRadiusPercent];
}

- (void)setTransparentCircleRadiusPercent:(NSNumber *)transparentCircleRadiusPercent {
    self.chartView.transparentCircleRadiusPercent = [RCTConvert BOOL:transparentCircleRadiusPercent];
}

- (void)setRotationEnabled:(NSNumber *)rotationEnabled {
    self.chartView.rotationEnabled = [RCTConvert BOOL:rotationEnabled];
}

- (void)setDataSets:(NSArray<NSDictionary *> *)dataSets {
    NSMutableArray<PieChartDataSet *> *dataSetObjs = [NSMutableArray array];

    for (NSDictionary *dataSetDict in dataSets) {
        PieChartDataSet *dataSet = [RNChartDataHelper pieDataSetWithDict:dataSetDict];
        if (dataSet) {
            [dataSetObjs addObject:dataSet];
        }
    }

    self.chartView.data = [[PieChartData alloc] initWithDataSets:[dataSetObjs copy]];
}

@end

@implementation RNPieChartManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(chartDescription, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(legend, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(holeColor, NSNumber *)
RCT_EXPORT_VIEW_PROPERTY(drawHole, NSNumber *)
RCT_EXPORT_VIEW_PROPERTY(holeRadiusPercent, NSNumber *)
RCT_EXPORT_VIEW_PROPERTY(transparentCircleRadiusPercent, NSNumber *)
RCT_EXPORT_VIEW_PROPERTY(rotationEnabled, NSNumber *)
RCT_EXPORT_VIEW_PROPERTY(dataSets, NSArray *)

- (UIView *)view {
    return [[RNPieChart alloc] init];
}

@end
