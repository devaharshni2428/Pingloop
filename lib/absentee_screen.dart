import 'package:flutter/material.dart';
import 'app_data.dart';

class AbsenteeScreen extends StatelessWidget {
  final String title;
  final String department;
  final String? year;
  final String? section;
  final List<Map<String,dynamic>>? absentees;
  const AbsenteeScreen({super.key,required this.title,required this.department,this.year,this.section,this.absentees});

  @override Widget build(BuildContext context){
    List<Map<String,dynamic>> list;
    if(absentees!=null){ list=absentees!; }
    else if(department=='All Departments'){
      list=[];
      for(final record in AppData.recentAttendance){
        final a=record['absentees'] as List;
        for(final student in a){ list.add({'name':student['name'],'roll':student['roll'],'department':record['department'],'year':record['year'],'section':record['section']}); }
      }
    } else {
      list=[];
      for(final record in AppData.recentAttendance.where((r)=>r['department']==department)){
        if(year!=null && record['year']!=year) continue;
        if(section!=null && record['section']!=section) continue;
        final a=record['absentees'] as List;
        for(final student in a){ list.add({'name':student['name'],'roll':student['roll'],'department':record['department'],'year':record['year'],'section':record['section']}); }
      }
    }
    return Scaffold(
      backgroundColor:const Color(0xFFE8F7F7),
      appBar:AppBar(backgroundColor:const Color(0xFF164A4A),foregroundColor:Colors.white,title:Text(title),centerTitle:true,
        leading:IconButton(icon:const Icon(Icons.arrow_back),onPressed:()=>Navigator.pop(context)),
        actions:[IconButton(icon:const Icon(Icons.home_outlined),onPressed:()=>Navigator.popUntil(context,(r)=>r.isFirst))]),
      body:Padding(padding:const EdgeInsets.all(18),child:Column(children:[
        Container(width:double.infinity,padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Absentee Report',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold,color:Color(0xFF164A4A))),const SizedBox(height:7),
          Text(department=='All Departments'?'All Departments':AppData.departmentNames[department]??department,style:const TextStyle(color:Colors.grey)),
          if(year!=null && section!=null) Text('$year • Section $section',style:const TextStyle(color:Colors.grey)),
          const SizedBox(height:8),Text('${list.length} absent record(s)',style:const TextStyle(fontWeight:FontWeight.w600,color:Colors.red)),
        ])),const SizedBox(height:15),
        Expanded(child:list.isEmpty?const Center(child:Text('No absentee records yet 🎉',style:TextStyle(fontSize:18,fontWeight:FontWeight.w600,color:Color(0xFF164A4A)))):ListView.builder(itemCount:list.length,itemBuilder:(context,index){final s=list[index];return Card(color:Colors.white,margin:const EdgeInsets.only(bottom:10),child:ListTile(leading:const CircleAvatar(backgroundColor:Color(0xFFFFE5E5),child:Icon(Icons.person_off_outlined,color:Colors.red)),title:Text(s['name']??'',style:const TextStyle(fontWeight:FontWeight.w600)),subtitle:Text('${s['roll']??''}${s['department']!=null?' • ${s['department']}':''}${s['year']!=null?' • ${s['year']}':''}${s['section']!=null?' • ${s['section']}':''}'),trailing:const Text('ABSENT',style:TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize:12))));})),
      ])),
    );
  }
}
