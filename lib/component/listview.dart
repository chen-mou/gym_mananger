// class TarBarListView<T> extends StatefulWidget {
//   final Map<String, List<T>> children;
//   final Widget Function(T) childBuilder;
//
//
//   const TarBarListView({super.key, required this.children, required this.childBuilder});
//
//   @override
//   State<TarBarListView> createState() => _TarBarListViewState();
// }
//
// class _TarBarListViewState extends State<TarBarListView> {
//   var now = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     int count = 0;
//     widget.children.forEach((key, value) {
//       count += value.length;
//     });
//     var klen = widget.children.keys.length;
//     var kindex = 0;
//     return Expanded(child: LayoutBuilder(builder: (ctx, con) {
//       return Row(
//         children: [
//           Container(
//             width: con.maxWidth * 0.2,
//             height: con.maxHeight,
//             decoration: const BoxDecoration(
//               color: Color(0xffeaebf1),
//             ),
//             child: ListView.builder(itemBuilder: (ctx, i) {
//               return Listener(
//                 onPointerDown: (e) {
//                   now = i;
//                   setState(() {});
//                 },
//                 child: Container(
//                   width: con.maxWidth * 0.2,
//                   height: 50,
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: (now == i ? Colors.white : Colors.transparent),
//                   ),
//                   child: Center(
//                     child: Text(
//                       widget.children.keys.elementAt(i),
//                       style: TextStyle(
//                           color: i == now ? Colors.blueGrey : Colors.black),
//                     ),
//                   ),
//                 ),
//               );
//             }, itemCount: klen,),
//           ),
//           Expanded(
//               flex: 1,
//               child: ListView.builder(itemBuilder: (ctx, i){
//                 if(i == 0 || ){}
//               }, itemCount: count + klen,))
//         ],
//       );
//     }));
//   }
// }
