import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post List',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.light(background: Color(0xFFF4F4F4))),
      home: PostListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<Post> posts = [
    Post(
      'Askeladd',
      'https://i.pinimg.com/originals/09/67/08/096708658b96878d36179b8f131cb056.jpg',
      'Curabitur egestas condimentum diam, sit amet scelerisque neque faucibus sit amet. ',
    ),
    Post(
      'Thorfinn',
      'https://staticg.sportskeeda.com/editor/2023/01/9d6e3-16738980415090-1920.jpg',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse lobortis vitae lacus tempus hendrerit. Proin mattis dignissim mi. Curabitur egestas condimentum diam, sit amet scelerisque neque faucibus sit amet. ',
    ),
    Post(
      'Arneis',
      'https://static.wikia.nocookie.net/vinlandsaga/images/8/81/Arnheid_profile_image.png/revision/latest?cb=20190628144910',
      'Lorem ipsum dolor sit amet,consectetur adipiscing elit. Suspendisse lobortis vitae lacus tempus hendrerit.',
    ),
  ];
  List<Post> filteredPosts = [];

  @override
  void initState() {
    super.initState();
    filteredPosts = List.from(posts); // Initialize filteredPosts with all posts
  }

  void filterPosts(String query) {
    setState(() {
      filteredPosts = posts
          .where((post) =>
              post.name.toLowerCase().contains(query.toLowerCase()) ||
              post.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => filterPosts(value),
              decoration: InputDecoration(
                labelText: 'Search',
                filled: true,
                fillColor: Colors.grey[300], // Customize the background color
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostDetailsScreen(filteredPosts[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(filteredPosts[index].avatarUrl),
                          ),
                          title: Text(filteredPosts[index].name),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(filteredPosts[index].content),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PostDetailsScreen extends StatefulWidget {
  final Post post;

  PostDetailsScreen(this.post);

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  bool showComments = false;
  List<Comment> comments = [
    Comment(
      'John Smith',
      'https://comicvine.gamespot.com/a/uploads/scale_small/11141/111415385/7549901-gudrid.jpg',
      'Comment đầu tiên của tôi.',
    ),
    Comment(
      'Jane Doe',
      'https://comicvine.gamespot.com/a/uploads/scale_small/11141/111415385/7549901-gudrid.jpg',
      'Ôi người viết ra post này hẳn phải là một thiên tài về toán học, thiên văn học, tin học, lịch sử, địa lý, vật lý học, sinh học, hóa học.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 0, right: 0),
              padding: EdgeInsets.only(left: 0, right: 0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.post.avatarUrl),
                ),
                title: Text(widget.post.name),
              ),
            ),
            SizedBox(height: 8),
            Text(widget.post.content),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showComments = !showComments;
                    });
                  },
                  child: Text(showComments ? 'Hide Comments' : 'View Comments'),
                ),
              ),
            ),
            if (showComments)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var comment in comments)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(comment.avatarUrl),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  // Wrap with Expanded
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(comment.name),
                                      Text(
                                        comment.content,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ],
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
}

class Post {
  final String name;
  final String avatarUrl;
  final String content;

  Post(this.name, this.avatarUrl, this.content);
}

class Comment {
  final String name;
  final String avatarUrl;
  final String content;

  Comment(this.name, this.avatarUrl, this.content);
}
