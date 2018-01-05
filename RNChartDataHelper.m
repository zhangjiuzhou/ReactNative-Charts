//
// RNChartDataHelper.m
// RNCharts
//
// Created by 张九州 on 2017/6/20,
//

#import "RNChartDataHelper.h"
#import <React/RCTConvert.h>
#import <CTools/CFormatHelper.h>

@implementation RNChartDataHelper

+ (LineChartDataSet *)lineDataSetWithDict:(NSDictionary *)dict {
    NSString *label = dict[@"label"];
    NSArray *values = dict[@"values"] ? : @[];
    if ([values isKindOfClass:[NSNull class]]) {
        return nil;
    }

    NSMutableArray *dataEntries = [NSMutableArray array];
    for (NSDictionary *dataEntryDict in values) {
        double x = [dataEntryDict[@"x"] doubleValue];
        double y = [dataEntryDict[@"y"] doubleValue];
        NSMutableDictionary *mDict = [dataEntryDict mutableCopy];
        [mDict removeObjectForKey:@"x"];
        [mDict removeObjectForKey:@"y"];
        ChartDataEntry *dataEntry = [[ChartDataEntry alloc] initWithX:x y:y data:mDict];
        [dataEntries addObject:dataEntry];
    }

    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:[dataEntries copy]
                                                                   label:label];

    if (dict[@"drawCircles"]) {
        dataSet.drawCirclesEnabled = [dict[@"drawCircles"] boolValue];
    }

    if (dict[@"lineWidth"]) {
        dataSet.lineWidth = [dict[@"lineWidth"] floatValue];
    }

    if (dict[@"circleColors"]) {
        NSMutableArray *circleColors = [NSMutableArray array];
        for (id color in dict[@"circleColors"]) {
            [circleColors addObject:[RCTConvert UIColor:color]];
        }
        dataSet.circleColors = [circleColors copy];
    }

    if (dict[@"circleHoleColor"]) {
        dataSet.circleHoleColor = [RCTConvert UIColor:dict[@"circleHoleColor"]];
    }

    if (dict[@"circleRadius"]) {
        dataSet.circleRadius = [dict[@"circleRadius"] floatValue];
    }

    if (dict[@"circleHoleRadius"]) {
        dataSet.circleHoleRadius = [dict[@"circleHoleRadius"] floatValue];
    }

    if (dict[@"drawCircleHole"]) {
        dataSet.drawCircleHoleEnabled = [dict[@"drawCircleHole"] boolValue];
    }

    if (dict[@"drawFilledEnabled"]) {
        dataSet.drawFilledEnabled = [dict[@"drawFilledEnabled"] boolValue];
    }
    
    if (dict[@"fillColor"]) {
        dataSet.fillColor = [RCTConvert UIColor:dict[@"fillColor"]];
    }

    [self _updateDataSet:dataSet withDict:dict];
    [self _updateLineScatterCandleRadarChartDataSet:dataSet withDict:dict];
    [self _updateBarLineScatterCandleBubbleChartDataSet:dataSet withDict:dict];

    return dataSet;
}

+ (BarChartDataSet *)barDataSetWithDict:(NSDictionary *)dict {
    NSString *label = dict[@"label"];
    NSArray *values = dict[@"values"] ? : @[];
    if ([values isKindOfClass:[NSNull class]]) {
        return nil;
    }

    NSMutableArray *dataEntries = [NSMutableArray array];
    for (NSDictionary *dataEntryDict in values) {
        double x = [dataEntryDict[@"x"] doubleValue];
        double y = [dataEntryDict[@"y"] doubleValue];
        BarChartDataEntry *dataEntry = [[BarChartDataEntry alloc] initWithX:x y:y data:nil];
        [dataEntries addObject:dataEntry];
    }

    BarChartDataSet *dataSet = [[BarChartDataSet alloc] initWithValues:[dataEntries copy]
                                                                 label:label];


    [self _updateDataSet:dataSet withDict:dict];
    [self _updateBarLineScatterCandleBubbleChartDataSet:dataSet withDict:dict];

    return dataSet;
}

+ (PieChartDataSet *)pieDataSetWithDict:(NSDictionary *)dict {
    NSString *label = dict[@"label"];
    NSArray *values = dict[@"values"] ? : @[];
    if ([values isKindOfClass:[NSNull class]]) {
        return nil;
    }

    NSMutableArray *dataEntryObjs = [NSMutableArray array];
    for (NSDictionary *value in values) {
        PieChartDataEntry *dataEntryObj = [[PieChartDataEntry alloc] initWithValue:[RCTConvert double:value[@"value"]] label:value[@"label"]];
        [dataEntryObjs addObject:dataEntryObj];
    }

    PieChartDataSet *dataSetObj = [[PieChartDataSet alloc] initWithValues:[dataEntryObjs copy] label:label];

    if (dict[@"sliceSpace"]) {
        dataSetObj.sliceSpace = [RCTConvert CGFloat:dict[@"sliceSpace"]];
    }

    if (dict[@"selectionShift"]) {
        dataSetObj.selectionShift = [RCTConvert BOOL:dict[@"selectionShift"]];
    }
    dataSetObj.entryLabelColor = [UIColor clearColor];

    [self _updateDataSet:dataSetObj withDict:dict];

    return dataSetObj;
}

+ (CandleChartDataSet *)candleStickDataSetWithDict:(NSDictionary *)dict {
    NSString *label = dict[@"label"];
    NSArray *values = dict[@"values"] ? : @[];
    if ([values isKindOfClass:[NSNull class]]) {
        return nil;
    }

    NSMutableArray *dataEntryObjs = [NSMutableArray array];

    int i = 0;
    for (NSDictionary *value in values) {
        double x = [value[@"xIndex"] doubleValue];
        double shadowH = [value[@"shadowH"] doubleValue];
        double shadowL = [value[@"shadowL"] doubleValue];
        double open = [value[@"open"] doubleValue];
        double close = [value[@"close"] doubleValue];
        NSMutableDictionary *mDict = [value mutableCopy];
        [mDict removeObjectForKey:@"x"];
        [mDict removeObjectForKey:@"shadowH"];
        [mDict removeObjectForKey:@"shadowL"];
        [mDict removeObjectForKey:@"open"];
        [mDict removeObjectForKey:@"close"];

        CandleChartDataEntry *dataEntryObj = [[CandleChartDataEntry alloc] initWithX:x
                                                                          shadowH:shadowH
                                                                          shadowL:shadowL
                                                                             open:open
                                                                            close:close
                                                                                icon:nil];
        [dataEntryObjs addObject:dataEntryObj];

        i+=1;
    }

    CandleChartDataSet *dataSet = [[CandleChartDataSet alloc] initWithValues:dataEntryObjs
                                                                       label:label];

    if (dict[@"increasingColor"]) {
        dataSet.increasingColor = [RCTConvert UIColor:dict[@"increasingColor"]];
    }

    if (dict[@"decreasingColor"]) {
        dataSet.decreasingColor = [RCTConvert UIColor:dict[@"decreasingColor"]];
    }

    if (dict[@"neutralColor"]) {
        dataSet.neutralColor = [RCTConvert UIColor:dict[@"neutralColor"]];
    }

    if (dict[@"increasingFilled"]) {
        dataSet.increasingFilled = [dict[@"increasingFilled"] boolValue];
    }

    if (dict[@"decreasingFilled"]) {
        dataSet.decreasingFilled = [dict[@"decreasingFilled"] boolValue];
    }

    if (dict[@"barSpace"]) {
        dataSet.barSpace = [dict[@"barSpace"] floatValue];
    }

    if (dict[@"shadowWidth"]) {
        dataSet.shadowWidth = [dict[@"shadowWidth"] floatValue];
    }

    if (dict[@"shadowColorSameAsCandle"]) {
        dataSet.shadowColorSameAsCandle = [dict[@"shadowColorSameAsCandle"] boolValue];
    }

    [self _updateDataSet:dataSet withDict:dict];
    [self _updateLineScatterCandleRadarChartDataSet:dataSet withDict:dict];
    [self _updateBarLineScatterCandleBubbleChartDataSet:dataSet withDict:dict];

    return dataSet;
}

+ (void)updateViewPointOffsets:(BarLineChartViewBase *)chartView withDict:(NSDictionary *)dict {
    [chartView setViewPortOffsetsWithLeft:[dict[@"left"] floatValue]
                                      top:[dict[@"top"] floatValue]
                                    right:[dict[@"right"] floatValue]
                                   bottom:[dict[@"bottom"] floatValue]];
}

+ (void)updateChartDescription:(ChartDescription *)chartDescription withDict:(NSDictionary *)dict {
    chartDescription.text = dict[@"text"];
    if (dict[@"fontSize"]) {
        chartDescription.font = [UIFont systemFontOfSize:[dict[@"fontSize"] floatValue]];
    }
    if (dict[@"color"]) {
        chartDescription.textColor = [RCTConvert UIColor:dict[@"color"]];
    }
}

+ (void)updateLegend:(ChartLegend *)legend withDict:(NSDictionary *)dict {
    if (dict[@"enabled"]) {
        legend.enabled = [dict[@"enabled"] boolValue];
    }

    if (dict[@"horizontalAlignment"]) {
        NSString *horizontalAlignment = dict[@"horizontalAlignment"];
        if ([horizontalAlignment isEqualToString:@"left"]) {
            legend.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
        } else if ([horizontalAlignment isEqualToString:@"center"]) {
            legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
        } else if ([horizontalAlignment isEqualToString:@"right"]) {
            legend.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
        }
    }

    if (dict[@"verticalAlignment"]) {
        NSString *verticalAlignment = dict[@"verticalAlignment"];
        if ([verticalAlignment isEqualToString:@"top"]) {
            legend.horizontalAlignment = ChartLegendVerticalAlignmentTop;
        } else if ([verticalAlignment isEqualToString:@"center"]) {
            legend.horizontalAlignment = ChartLegendVerticalAlignmentCenter;
        } else if ([verticalAlignment isEqualToString:@"bottom"]) {
            legend.horizontalAlignment = ChartLegendVerticalAlignmentBottom;
        }
    }

    if (dict[@"xEntrySpace"]) {
        legend.xEntrySpace = [dict[@"xEntrySpace"] floatValue];
    }

    if (dict[@"yEntrySpace"]) {
        legend.yEntrySpace = [dict[@"yEntrySpace"] floatValue];
    }
}

+ (void)updateXAxis:(ChartXAxis *)xAxis withDict:(NSDictionary *)dict {
    [self updateXAxis:xAxis withDict:dict xValues:nil];
}

+ (void)updateXAxis:(ChartXAxis *)xAxis withDict:(NSDictionary *)dict xValues:(NSArray *)xValues {
    if (dict[@"position"]) {
        NSNumber *pos = [self _convertXAxisPosition:dict[@"position"]];
        if (pos) {
            xAxis.labelPosition = pos.integerValue;
        }
    }

    [self _updateAxis:xAxis withDict:dict xValues:xValues];
}

+ (void)updateYAxis:(ChartYAxis *)yAxis withDict:(NSDictionary *)dict {
    if (dict[@"position"]) {
        NSNumber *pos = [self _convertYAxisPosition:dict[@"position"]];
        if (pos) {
            yAxis.labelPosition = pos.integerValue;
        }
    }

    [self _updateAxis:yAxis withDict:dict xValues:nil];
}

+ (ChartMarkerImage *)markerWithDict:(NSDictionary *)dict {
    NSString *html = dict[@"html"];
    if (!html) {
        return nil;
    }

    BalloonMarker *balloonMarker = [BalloonMarker new];
    balloonMarker.html = html;
    balloonMarker.color = [RCTConvert UIColor:dict[@"color"]] ? : [UIColor grayColor];
    if (dict[@"insets"]) {
        balloonMarker.insets = [RCTConvert UIEdgeInsets:dict[@"insets"]];
    } else {
        balloonMarker.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    if (dict[@"formatters"]) {
        NSMutableDictionary *mFormatters = [NSMutableDictionary dictionary];
        for (NSString *k in dict[@"formatters"]) {
            mFormatters[k] = [self _formatterWithDict:dict[@"formatters"][k] xValues:nil];
        }
        balloonMarker.formatters = [mFormatters copy];
    }

    return balloonMarker;
}

+ (void)_updateDataSet:(ChartBaseDataSet *)dataSet withDict:(NSDictionary *)dict {
    if (dict[@"colors"]) {
        NSMutableArray *colors = [NSMutableArray array];
        for (id color in dict[@"colors"]) {
            [colors addObject:[RCTConvert UIColor:color]];
        }
        dataSet.colors = [colors copy];
    }

    if (dict[@"drawValues"]) {
        dataSet.drawValuesEnabled = [dict[@"drawValues"] boolValue];
    }

    if (dict[@"highlightEnabled"]) {
        dataSet.highlightEnabled = [dict[@"highlightEnabled"] boolValue];
    }

    if (dict[@"form"]) {
        NSNumber *form = [self _converForm:dict[@"form"]];
        if (form) {
            dataSet.form = form.integerValue;
        }
    }
}

+ (void)_updateLineScatterCandleRadarChartDataSet:(LineScatterCandleRadarChartDataSet *)dataSet withDict:(NSDictionary *)dict {
    if (dict[@"drawHorizontalHighlightIndicator"]) {
        dataSet.drawHorizontalHighlightIndicatorEnabled = [dict[@"drawHorizontalHighlightIndicator"] boolValue];
    }

    if (dict[@"drawVerticalHighlightIndicator"]) {
        dataSet.drawVerticalHighlightIndicatorEnabled = [dict[@"drawVerticalHighlightIndicator"] boolValue];
    }
}

+ (void)_updateBarLineScatterCandleBubbleChartDataSet:(BarLineScatterCandleBubbleChartDataSet *)dataSet
                                             withDict:(NSDictionary *)dict {
    if (dict[@"highlightColor"]) {
        dataSet.highlightColor = [RCTConvert UIColor:dict[@"highlightColor"]];
    }

    if (dict[@"highlightLineWidth"]) {
        dataSet.highlightLineWidth = [dict[@"highlightLineWidth"] floatValue];
    }
}

+ (void)_updateAxis:(ChartAxisBase *)axis withDict:(NSDictionary *)dict xValues:(NSArray *)xValues {
    if (dict[@"limitLines"]) {
        NSArray *limitLines = [RCTConvert NSDictionaryArray:dict[@"limitLines"]];
        for (NSDictionary *_limitLine in limitLines) {
            [axis addLimitLine:[self _limitLineWithDict:_limitLine]];
        }
    }

    if (dict[@"enabled"]) {
        axis.enabled = [dict[@"enabled"] boolValue];
    }

    if (dict[@"xOffset"]) {
        axis.xOffset = [dict[@"xOffset"] floatValue];
    }

    if (dict[@"yOffset"]) {
        axis.yOffset = [dict[@"yOffset"] floatValue];
    }

    if (dict[@"axisMinimum"]) {
        axis.axisMinimum = [dict[@"axisMinimum"] doubleValue];
    }

    if (dict[@"axisMaximum"]) {
        axis.axisMaximum = [dict[@"axisMaximum"] doubleValue];
    }

    if (dict[@"labelCount"]) {
        [axis setLabelCount:[dict[@"labelCount"] integerValue] force:YES];
    }

    if (dict[@"drawAxisLine"]) {
        axis.drawAxisLineEnabled = [dict[@"drawAxisLine"] boolValue];
    }

    if (dict[@"drawGridLines"]) {
        axis.drawGridLinesEnabled = [dict[@"drawGridLines"] boolValue];
    }

    if (dict[@"drawLabels"]) {
        axis.drawLabelsEnabled = [dict[@"drawLabels"] boolValue];
    }

    if (dict[@"textColor"]) {
        axis.labelTextColor = [RCTConvert UIColor:dict[@"textColor"]];
    }

    if (dict[@"textSize"]) {
        axis.labelFont = [axis.labelFont fontWithSize:[dict[@"textSize"] floatValue]];
    }

    if (dict[@"gridLineColor"]) {
        axis.gridColor = [RCTConvert UIColor:dict[@"gridLineColor"]];
    }

    if (dict[@"gridLineWidth"]) {
        axis.gridLineWidth = [dict[@"gridLineWidth"] doubleValue];
    }

    if (dict[@"axisLineColor"]) {
        axis.axisLineColor = [RCTConvert UIColor:dict[@"axisLineColor"]];
    }

    if (dict[@"axisLineWidth"]) {
        axis.axisLineWidth = [dict[@"axisLineWidth"] doubleValue];
    }

    if (dict[@"formatter"]) {
        NSDictionary *formatter = dict[@"formatter"];
        id fmtObj = [self _formatterWithDict:formatter xValues:xValues];
        if (fmtObj) {
            axis.valueFormatter = fmtObj;
        }
    }
}

+ (NSNumber *)_convertXAxisPosition:(NSString *)position {
    if ([position isEqualToString:@"top"]) {
        return @(XAxisLabelPositionTop);
    } else if ([position isEqualToString:@"bottom"]) {
        return @(XAxisLabelPositionBottom);
    } else if ([position isEqualToString:@"both"]) {
        return @(XAxisLabelPositionBothSided);
    } else if ([position isEqualToString:@"topInside"]) {
        return @(XAxisLabelPositionTopInside);
    } else if ([position isEqualToString:@"bottomInside"]) {
        return @(XAxisLabelPositionBottomInside);
    } else {
        return nil;
    }
}

+ (NSNumber *)_convertYAxisPosition:(NSString *)position {
    if ([position isEqualToString:@"inside"]) {
        return @(YAxisLabelPositionInsideChart);
    } else if ([position isEqualToString:@"outside"]) {
        return @(YAxisLabelPositionOutsideChart);
    } else {
        return nil;
    }
}

+ (NSNumber *)_converForm:(NSString *)string {
    if ([string isEqualToString:@"none"]) {
        return @(ChartLegendFormNone);
    } else if ([string isEqualToString:@"empty"]) {
        return @(ChartLegendFormEmpty);
    } else if ([string isEqualToString:@"default"]) {
        return @(ChartLegendFormDefault);
    } else if ([string isEqualToString:@"square"]) {
        return @(ChartLegendFormSquare);
    } else if ([string isEqualToString:@"circle"]) {
        return @(ChartLegendFormCircle);
    } else if ([string isEqualToString:@"line"]) {
        return @(ChartLegendFormLine);
    } else {
        return nil;
    }
}

+ (id)_formatterWithDict:(NSDictionary *)dict xValues:(NSArray *)xValues {
    NSString *type = dict[@"type"];

    double (^getXValue)(double) = ^(double value) {
        if (xValues) {
            NSUInteger xIndex = (NSUInteger)value;
            if (xIndex < xValues.count) {
                value = [xValues[xIndex] doubleValue];
            } else {
                value = 0;
            }
        }
        return value;
    };

    if ([type isEqualToString:@"datetime"]) {
        return [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase *axis) {
            float val = [dict[@"ms"] boolValue] ? getXValue(value) / 1000 : getXValue(value);
            return [CFormatHelper timestamp:val format:dict[@"format"] ? : CFormatHelper.fullDateFormat];
        }];
    } else if ([type isEqualToString:@"number"]) {
        return [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase *axis) {
            NSNumber *digits = dict[@"digits"] ? : @0;
            return [CFormatHelper number:@(getXValue(value))
                                 options:@{
                                           CFormatHelper.digits: digits
                                           }];
        }];
    } else if ([type isEqualToString:@"space"]) { // 空白formatter是解决横轴右侧被遮挡的问题，加上空白使图表右边距变大
        return [ChartDefaultAxisValueFormatter withBlock:^NSString * _Nonnull(double value, ChartAxisBase *axis) {
            const unichar space = ' ';
            return [NSString stringWithCharacters:&space length:[dict[@"length"] unsignedIntegerValue]];
        }];
    } else {
        return nil;
    }
}

+ (ChartLimitLine *)_limitLineWithDict:(NSDictionary *)dict {
    double limit = [dict[@"limit"] doubleValue];
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:limit
                                                                label:dict[@"label"]];

    if (dict[@"labelPosition"]) {
        NSString *labelPosition = dict[@"labelPosition"];
        if ([labelPosition isEqualToString:@"leftTop"]) {
            limitLine.labelPosition = ChartLimitLabelPositionLeftTop;
        } else if ([labelPosition isEqualToString:@"leftBottom"]) {
            limitLine.labelPosition = ChartLimitLabelPositionLeftBottom;
        } else if ([labelPosition isEqualToString:@"rightTop"]) {
            limitLine.labelPosition = ChartLimitLabelPositionRightTop;
        } else if ([labelPosition isEqualToString:@"rightBottom"]) {
            limitLine.labelPosition = ChartLimitLabelPositionRightBottom;
        }
    }

    if (dict[@"fontSize"]) {
        limitLine.valueFont = [UIFont systemFontOfSize:[dict[@"fontSize"] floatValue]];
    }

    if (dict[@"color"]) {
        limitLine.valueTextColor = [RCTConvert UIColor:dict[@"color"]];
    }

    if (dict[@"lineWidth"]) {
        limitLine.lineWidth = [dict[@"lineWidth"] floatValue];
    }

    if (dict[@"lineColor"]) {
        limitLine.lineColor = [RCTConvert UIColor:dict[@"lineColor"]];
    }

    return limitLine;
}

@end
