import 'package:flutter/material.dart';

/// A custom indicator that can be used to show awaed indicator implemented by Maximus Ashraf

class MAXIndicator extends StatefulWidget {
  final ValueNotifier<bool>? isRefreshing;
  // indicator builder
  final Widget Function(
    BuildContext context,
    double animationValue,
    bool isRefreshing,
  ) indicatorBuilder;

  final double indicatorHeight;
  final double indicatorSpacing;
  final Widget child;
  final Future Function() onRefresh;
  final double refreshFactor;

  const MAXIndicator({
    super.key,
    this.isRefreshing,
    required this.child,
    required this.onRefresh,
    required this.indicatorBuilder,
    required this.indicatorHeight,
    this.indicatorSpacing = 48,
    this.refreshFactor = 1,
  });

  @override
  State<MAXIndicator> createState() => _MAXIndicatorState();
}

class _MAXIndicatorState extends State<MAXIndicator> {
  bool _isRefreshing = false;
  bool _shouldLoading = false;
  final ValueNotifier<double> _indicatorYAxise = ValueNotifier<double>(0.0);

  late final double _indicatorHeight;
  late final double _indicatorLoadingHeight;

  /// the factor to detect the refresh hit in % of the indicator height
  /// more than 1 will make the refresh hit harder
  late final double _indicatorRefreshFactor;

  double _firstTapIndex = 0;

  _isRefreshingListener() {
    if (widget.isRefreshing?.value == true) {
      _startIndicator();
    } else {
      _resetIndicator();
    }
  }

  _resetIndicator() {
    _isRefreshing = false;
    _shouldLoading = false;
    _firstTapIndex = 0;
    _indicatorYAxise.value = 0;
  }

  _startIndicator() {
    _isRefreshing = true;
    _indicatorYAxise.value = _indicatorLoadingHeight - .0001;
  }

  bool _detectRefreshHit(ScrollNotification notification) {
    final pixels = notification.metrics.pixels;
    if (pixels >= 0) {
      return _detectClampingRefreshHit(notification);
    } else {
      return _detectBouncingRefreshHit(notification);
    }
  }

  bool _detectClampingRefreshHit(ScrollNotification notification) {
    if (notification is OverscrollNotification) {
      if (_firstTapIndex == 0) {
        _firstTapIndex = notification.dragDetails?.globalPosition.dy ?? 0;
      }
      final lastDragIndex = notification.dragDetails?.globalPosition.dy ?? 0;
      _indicatorYAxise.value =
          ((lastDragIndex - _firstTapIndex) / _indicatorRefreshFactor)
              .clamp(0, _indicatorLoadingHeight);
      if (!_isRefreshing &&
          _indicatorYAxise.value >=
              _indicatorLoadingHeight * _indicatorRefreshFactor) {
        _shouldLoading = true;
      } else {
        _shouldLoading = false;
      }

      return false;
    }

    if (notification is ScrollUpdateNotification && _firstTapIndex != 0) {
      final lastDragIndex = notification.dragDetails?.globalPosition.dy ?? 0;
      _indicatorYAxise.value =
          (lastDragIndex - _firstTapIndex).clamp(0, _indicatorLoadingHeight);
      if (!_isRefreshing &&
          _indicatorYAxise.value >=
              _indicatorLoadingHeight * _indicatorRefreshFactor) {
        _shouldLoading = true;
      } else {
        _shouldLoading = false;
      }

      return false;
    }

    if (notification is ScrollEndNotification) {
      if (_shouldLoading) {
        _onRefresh();
      } else {
        _resetIndicator();
        setState(() {});
      }
    }

    return false;
  }

  bool _detectBouncingRefreshHit(ScrollNotification notification) {
    final pixels = notification.metrics.pixels;
    if (pixels > 0) {
      if (notification is ScrollEndNotification && _indicatorYAxise.value > 0) {
        _indicatorYAxise.value = 0;
      }
      return false;
    }

    if (notification is ScrollUpdateNotification &&
        notification.dragDetails != null &&
        !_isRefreshing) {
      _indicatorYAxise.value = (pixels * -1 / _indicatorRefreshFactor)
          .clamp(0, _indicatorLoadingHeight);
      if (!_isRefreshing && _indicatorYAxise.value >= _indicatorLoadingHeight) {
        _shouldLoading = true;
      } else {
        _shouldLoading = false;
      }
    }

    if (notification is ScrollUpdateNotification &&
        notification.dragDetails == null &&
        _indicatorYAxise.value > 0) {
      if (_shouldLoading) {
        _onRefresh();
      } else {
        _resetIndicator();
      }
    }
    return false;
  }

  _onRefresh() async {
    if (_isRefreshing) return;
    if (widget.isRefreshing == null) _startIndicator();
    await widget.onRefresh();
    if (widget.isRefreshing == null) _resetIndicator();
  }

  @override
  void initState() {
    _indicatorRefreshFactor = widget.refreshFactor;
    _indicatorHeight = widget.indicatorHeight;
    _indicatorLoadingHeight = _indicatorHeight + widget.indicatorSpacing;
    widget.isRefreshing?.addListener(_isRefreshingListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.isRefreshing?.removeListener(_isRefreshingListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        return _detectRefreshHit(notification);
      },
      child: Column(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: _indicatorYAxise,
            builder: (context, value, child) {
              final double animationValue =
                  _indicatorYAxise.value / _indicatorLoadingHeight;
              print(
                  "animationValue: $animationValue , isRefreshing: $_isRefreshing");
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: value,
                  child: Opacity(
                    opacity: animationValue,
                    child: ClipRect(
                      child: OverflowBox(
                          maxHeight: _indicatorHeight,
                          minHeight: _indicatorHeight,
                          child: widget.indicatorBuilder(
                              context, animationValue, _isRefreshing)),
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
