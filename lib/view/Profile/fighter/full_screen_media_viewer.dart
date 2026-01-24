import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/models/profile_media_model.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenMediaViewer extends StatefulWidget {
  final List<ProfileMediaModel> mediaList;
  final int initialIndex;
  final bool isOwnProfile;
  final String userId;
  final Function(ProfileMediaModel)? onDelete;

  const FullScreenMediaViewer({
    super.key,
    required this.mediaList,
    required this.initialIndex,
    this.isOwnProfile = false,
    required this.userId,
    this.onDelete,
  });

  @override
  State<FullScreenMediaViewer> createState() => _FullScreenMediaViewerState();
}

class _FullScreenMediaViewerState extends State<FullScreenMediaViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  Future<void> _openVideoInBrowser(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open video: $e'),
          backgroundColor: AppColor.red,
        ),
      );
    }
  }

  void _deleteCurrentMedia() {
    final media = widget.mediaList[_currentIndex];
    if (widget.onDelete != null) {
      widget.onDelete!(media);
      if (widget.mediaList.length > 1) {
        // Navigate to previous item if available
        if (_currentIndex > 0) {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Media content
            PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final media = widget.mediaList[index];
                return _buildMediaContent(media);
              },
            ),

            // Controls overlay
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Top bar with close and delete buttons
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColor.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            if (widget.isOwnProfile && widget.onDelete != null)
                              GestureDetector(
                                onTap: _deleteCurrentMedia,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColor.red.withValues(alpha: 0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColor.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Spacer(),
                      // Bottom indicator
                      if (widget.mediaList.length > 1)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.mediaList.length,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == index
                                      ? AppColor.red
                                      : AppColor.white.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(ProfileMediaModel media) {
    // Check if URL is a video file
    final isVideoUrl = media.url.toLowerCase().endsWith('.mp4') ||
        media.url.toLowerCase().endsWith('.mov') ||
        media.url.toLowerCase().endsWith('.avi') ||
        media.url.toLowerCase().endsWith('.mkv') ||
        media.url.toLowerCase().endsWith('.webm') ||
        media.type == 'video';

    if (media.type == 'photo' && !isVideoUrl) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: media.url,
            fit: BoxFit.contain,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                color: AppColor.red,
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Icon(
                Icons.error_outline,
                color: AppColor.red,
                size: 48,
              ),
            ),
          ),
        ),
      );
    } else {
      // For videos, show placeholder with play button instead of trying to load video URL as image
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _openVideoInBrowser(media.url),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: AppColor.black,
                    child: Icon(
                      Icons.videocam,
                      color: AppColor.white.withValues(alpha: 0.3),
                      size: 80,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: AppColor.white,
                      size: 64,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Tap to play video',
              style: TextStyle(
                color: AppColor.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
  }
}
