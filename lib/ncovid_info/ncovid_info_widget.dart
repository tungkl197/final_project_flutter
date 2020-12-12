import 'package:final_project_flutter/model/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../dropdown_search_custom.dart';
import 'ncovid_info_bloc.dart';
import 'ncovid_info_event.dart';
import 'ncovid_info_state.dart';
import 'package:final_project_flutter/model/sample_view.dart';

class NcovidInfoWidget extends StatefulWidget {
  @override
  _NcovidInfoWidgetState createState() => _NcovidInfoWidgetState();
}

class _NcovidInfoWidgetState extends State<NcovidInfoWidget> {
  Bloc bloc;
  final controller = ScrollController();
  double offset = 0;
  final formatter = new NumberFormat("#,###");

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    bloc.add(RefeshEvent());
    _refreshController.refreshCompleted();
    _showMyDialog("Thông tin của bạn đã được cập nhật mới nhất");
  }

  @override
  void initState() {
    bloc = NcovidInfoBloc();
    bloc.add(InitialEvent());
    controller.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NcovidInfoBloc, NcovidInfoState>(
        cubit: bloc,
        builder: (context, state) {
          // if (state.errorMessage != null) _showMyDialog(state.errorMessage);
          // if (state.successMessage != null) _showMyDialog(state.successMessage);
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(
              backgroundColor: Color(0xFF11249F),
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              controller: controller,
              child: Column(children: <Widget>[
                _buildHeader(
                  image: "assets/images/covid_banner.png",
                  textTop: "Hãy chung",
                  textMid: "tay đẩy lùi đại",
                  textBottom: "dịch Covid-19",
                  offset: offset,
                ),
                if (state.lstCountries != null)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            maxHeight: 300,
                            items: state.countryName == null
                                ? []
                                : state.countryName,
                            onChanged: (data) {
                              bloc.add(ChangeCountryEvent(data));
                            },
                            // onFind: (String filter) => _searchData(filter),
                            selectedItem: "Viet Nam",
                            showSearchBox: true,
                            searchBoxDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "Tên nước bạn muốn tìm kiếm",
                            ),
                            popupTitle: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xFF3383CD),
                                    Color(0xFF11249F),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Tìm kiếm thông tin',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 24,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            popupShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        SvgPicture.asset("assets/icons/dropdown.svg"),
                      ],
                    ),
                  ),
                SizedBox(height: 20),
                if (state.countryInfo != null)
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Cập nhật mới nhất\n",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF303030),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "Ngày ${state.countryInfo == null ? 0 : state.dateUpdate}",
                                    style: TextStyle(
                                      color: Color(0xFF959595),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    )),
                SizedBox(height: 20),
                if (state.countryInfo != null)
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 30,
                        color: Color(0xFFB7B7B7).withOpacity(.16),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildCounter(
                          color: Color(0xFFFF8748),
                          number: state.countryInfo == null
                              ? 0
                              : state.countryInfo.totalConfirmed,
                          title: "Nhiễm bệnh",
                          numIncrease: state.countryInfo == null
                              ? 0
                              : state.countryInfo.newConfirmed),
                      _buildCounter(
                          color: Color(0xFFFF4848),
                          number: state.countryInfo == null
                              ? 0
                              : state.countryInfo.totalDeaths,
                          title: "Tử vong",
                          numIncrease: state.countryInfo == null
                              ? 0
                              : state.countryInfo.newDeaths),
                      _buildCounter(
                          color: Color(0xFF36C12C),
                          number: state.countryInfo == null
                              ? 0
                              : state.countryInfo.totalRecovered,
                          title: "Bình phục",
                          numIncrease: state.countryInfo == null
                              ? 0
                              : state.countryInfo.newRecovered),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (state.gbInfo != null)
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/icons/earth.svg",
                              height: 30.0,
                              width: 30.0,
                              color: Color(0xFF303030),
                            ),
                            SizedBox(width: 10),
                            RichText(
                              text: TextSpan(
                                text: "Thông tin thế giới",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF303030),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    )),
                SizedBox(height: 20),
                if (state.gbInfo != null)
                  Container(
                      // padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: Color(0xFFB7B7B7).withOpacity(.16),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          _getDefaultColumnChart(state.gbInfo),
                          SizedBox(
                            height: 10,
                          ),
                          _getCustomizedRadialBarChart(state.gbInfo)
                        ],
                      )),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      {String image,
      String textTop,
      String textMid,
      String textBottom,
      double offset}) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 20, right: 20),
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F),
            ],
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/virus_banner.png"),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: (offset < 0) ? 0 : offset,
                    left: -20,
                    child: Image.asset(
                      image,
                      width: 230,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Positioned(
                    top: 40 - offset / 2,
                    left: 200,
                    child: Text(
                      "${textTop} \n${textMid} \n${textBottom}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(
      {int number, int numIncrease, Color color, String title}) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          formatter.format(number),
          style: TextStyle(
            fontSize: 25,
            color: color,
          ),
        ),
        Text(title, style: TextStyle(fontSize: 16, color: Color(0xFF959595))),
        if (numIncrease != 0)
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/up-arrow.svg",
                height: 18.0,
                width: 18.0,
                color: color,
              ),
              Text(
                formatter.format(numIncrease),
                style: TextStyle(
                  fontSize: 18,
                  color: color,
                ),
              ),
            ],
          ),
      ],
    );
  }

  SfCircularChart _getCustomizedRadialBarChart(Global global) {
    final List<ChartSampleData> dataSources = <ChartSampleData>[
      ChartSampleData(
          x: 'Tử vong',
          y: 7,
          text: '10%',
          pointColor: const Color.fromRGBO(255, 72, 72, 1.0)),
      ChartSampleData(
          x: 'Bình phục',
          y: double.parse((double.parse(global.totalRecovered.toString()) *
                  100 /
                  double.parse(global.totalConfirmed.toString()))
              .toStringAsFixed(2)),
          text: '10%',
          pointColor: const Color.fromRGBO(54, 193, 44, 1.0)),
      ChartSampleData(
          x: 'Nhiễm bệnh',
          y: 100,
          text: '100%',
          pointColor: const Color.fromRGBO(255, 135, 72, 1.0)),
    ];

    final List<CircularChartAnnotation> _annotationSources =
        <CircularChartAnnotation>[
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Container(
          child: Image.asset(
            'assets/images/skull.png',
            width: 20,
            height: 20,
            color: const Color.fromRGBO(255, 72, 72, 1.0),
          ),
        ),
      ),
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Container(
          child: Image.asset(
            'assets/images/medical-insurance.png',
            width: 20,
            height: 20,
            color: const Color.fromRGBO(54, 193, 44, 1.0),
          ),
        ),
      ),
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Container(
          child: Image.asset('assets/images/virus.png',
              width: 20,
              height: 20,
              color: const Color.fromRGBO(255, 135, 72, 1.0)),
        ),
      ),
    ];

    const List<Color> colors = <Color>[
      Color.fromRGBO(255, 72, 72, 1.0),
      Color.fromRGBO(54, 193, 44, 1.0),
      Color.fromRGBO(255, 135, 72, 1.0)
    ];

    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        legendItemBuilder:
            (String name, dynamic series, dynamic point, int index) {
          return Container(
              height: 60,
              width: 160,
              child: Row(children: <Widget>[
                Container(
                    height: 75,
                    width: 65,
                    child: SfCircularChart(
                      annotations: <CircularChartAnnotation>[
                        _annotationSources[index],
                      ],
                      series: <RadialBarSeries<ChartSampleData, String>>[
                        RadialBarSeries<ChartSampleData, String>(
                            animationDuration: 0,
                            dataSource: <ChartSampleData>[dataSources[index]],
                            maximumValue: 100,
                            radius: '100%',
                            cornerStyle: CornerStyle.bothCurve,
                            xValueMapper: (ChartSampleData data, _) => point.x,
                            yValueMapper: (ChartSampleData data, _) => data.y,
                            pointColorMapper: (ChartSampleData data, _) =>
                                data.pointColor,
                            innerRadius: '70%',
                            pointRadiusMapper: (ChartSampleData data, _) =>
                                data.text),
                      ],
                    )),
                Container(
                    width: 87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          point.x,
                          style: TextStyle(color: colors[index]),
                        ),
                        // Text(
                        //   point.x,
                        //   style: TextStyle(color: colors[index]),
                        // )
                      ],
                    )),
              ]));
        },
      ),
      title: ChartTitle(text: 'Thông tin chung'),
      series: _getRadialBarCustomizedSeries(global),
      tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x'),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          angle: 0,
          radius: '0%',
          height: '90%',
          width: '90%',
          widget: Container(
            child: Image.asset(
              'assets/images/beatiful_earth.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns radial bar which need to be customized.
  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarCustomizedSeries(
      Global global) {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Tử vong\n ${formatter.format(global.totalDeaths)}',
          y: 5.0,
          text: '100%',
          pointColor: const Color.fromRGBO(255, 72, 72, 1.0)),
      ChartSampleData(
          x: 'Bình phục\n ${formatter.format(global.totalRecovered)}',
          y: double.parse((double.parse(global.totalRecovered.toString()) *
                  100 /
                  double.parse(global.totalConfirmed.toString()))
              .toStringAsFixed(2)),
          text: '100%',
          pointColor: const Color.fromRGBO(54, 193, 44, 1.0)),
      ChartSampleData(
          x: 'Nhiễm bệnh \n ${formatter.format(global.totalConfirmed)}',
          y: 100,
          text: '100%',
          pointColor: const Color.fromRGBO(255, 135, 72, 1.0)),
    ];
    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        animationDuration: 0,
        maximumValue: 100,
        gap: '10%',
        radius: '100%',
        dataSource: chartData,
        cornerStyle: CornerStyle.bothCurve,
        innerRadius: '50%',
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,

        /// Color mapper for each bar in radial bar series,
        /// which is get from datasource.
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        legendIconType: LegendIconType.circle,
      ),
    ];
  }

  SfCartesianChart _getDefaultColumnChart(Global global) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Thông tin cập nhật mới nhất'),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}',
          majorTickLines: MajorTickLines(size: 0)),
      series: _getDefaultColumnSeries(global),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries(
      Global global) {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Số ca nhiễm mới',
          y: double.parse(global.newConfirmed.toString()),
          pointColor: const Color.fromRGBO(255, 135, 72, 1.0)),
      ChartSampleData(
          x: 'Số ca bình phục mới',
          y: double.parse(global.newRecovered.toString()),
          pointColor: const Color.fromRGBO(54, 193, 44, 1.0)),
      ChartSampleData(
          x: 'Số ca tử vong mới',
          y: double.parse(global.newDeaths.toString()),
          pointColor: const Color.fromRGBO(255, 72, 72, 1.0)),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, textStyle: const TextStyle(fontSize: 10)),
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
      )
    ];
  }

  Future<void> _showMyDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(text),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Row(
                children: [
                  Icon(Icons.close),
                  Text('Đóng'),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
