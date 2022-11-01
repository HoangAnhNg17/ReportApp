import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network/bloc/content_bloc.dart';
import 'package:social_network/common/const.dart';
import 'package:social_network/common/widgets/toastOverlay.dart';
import 'package:social_network/model/Content.dart';
import 'package:social_network/module/drawer_page.dart';
import 'package:social_network/service/user_service.dart';
import '../model/user.dart';
import '../service/api_service.dart';

class NewsfeedPage extends StatefulWidget {
  const NewsfeedPage({Key? key}) : super(key: key);

  @override
  State<NewsfeedPage> createState() => _NewsfeedPageState();
}

class _NewsfeedPageState extends State<NewsfeedPage> {
  late ContentBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var remaining = 0;
  final ScrollController _scrollController = ScrollController();
  bool showBtn = false;
  var user = User();

  @override
  void initState() {
    bloc = ContentBloc();
    _scrollController.addListener(() {
      double showOffset = 10.0;

      if (_scrollController.offset > showOffset) {
        showBtn = true;
      } else {
        showBtn = false;
      }
    });
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerPage(user: user),
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Newsfeed'),
          centerTitle: true,
          leading: GestureDetector(
            child: const Icon(Icons.menu),
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        floatingActionButton: showBtn == false
            ? null
            : FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(0, duration: const Duration(seconds: 3), curve: Curves.linear);
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.arrow_upward),
              ),
        body: StreamBuilder<List<Content>>(
            stream: bloc.streamContent,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.hasData) {
                final contents = snapshot.data ?? [];
                return RefreshIndicator(
                  onRefresh: () async {
                    await bloc.getContents(isClear: true);
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final content = contents[index];
                      final photos = content.photos;
                      if (photos != null) {
                        remaining = photos.length - 4;
                      }
                      if (index == contents.length - 1) {
                        bloc.getContents();
                      }
                      remove(content);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: <Widget>[
                                  if (content.accountPublic?.avatar != null) ...{
                                    Container(
                                      margin: const EdgeInsets.only(right: 15),
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              handleLink(content.accountPublic?.avatar ?? '')
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  } else ...{
                                    Container(
                                      margin: const EdgeInsets.only(right: 15),
                                      width: 60,
                                      height: 60,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/avatar.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  },
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${content.accountPublic?.name}'),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${content.createdAt}',
                                          style: TextStyle(
                                              color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Trạng thái',
                                    style: TextStyle(
                                      color: content.isEnable ?? true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 3,
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    content.title ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(content.content ?? ''),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            // if (content.photos?.length != 0) ...{
                            //   _buildImageList(content, remaining)
                            // }
                            if (content.photos != null) ...{
                              if(content.photos!.isNotEmpty)...{
                                _buildImageList(content, remaining)
                              }
                            }
                          ],
                        ),
                      );
                    },
                    itemCount: contents.length,
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },),
      ),
    );
  }

  Widget _buildImageList(Content content, int remaining) {
    if (content.photos?.length == 1) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade100,
        ),
        alignment: Alignment.center,
        child: CachedNetworkImage(
          imageUrl: handleLink(content.photos?[0] ?? ''),
          placeholder: (context,url) => const CircularProgressIndicator(),
          errorWidget: (context,url,error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      );
    } else if (content.photos!.length <= 4) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: content.photos?.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade100,
            ),
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: handleLink(content.photos?[index] ?? ''),
              placeholder: (context,url) => const CircularProgressIndicator(),
              errorWidget: (context,url,error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          );
        },
      );
    } else {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          if (index == 3) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: handleLink(content.photos?[index] ?? ''),
                    placeholder: (context,url) => const CircularProgressIndicator(),
                    errorWidget: (context,url,error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: Text(
                      '+$remaining',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                )
              ],
            );
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade100,
            ),
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: handleLink(content.photos?[index] ?? ''),
              placeholder: (context,url) => const CircularProgressIndicator(),
              errorWidget: (context,url,error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
  }

  void getProfile() {
    apiService.getProfile().then((value) {
      setState(() {
        user = value;
      });
    }).catchError((e) {
      ToastOverlay(context).showToastOverlay(message: e.toString(), type: ToastType.error);
    });
  }

}

String handleLink(String url) {
  if (!url.contains(baseUrl)) {
    url = baseUrl + url;
  }
  return url;
}

void remove(Content content) {
  for (int i = 0; i < content.photos!.length; i++) {
    String? url = content.photos?[i] ;
    if (!url!.contains('uploads')) content.photos?.removeAt(i);
  }
}

