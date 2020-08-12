import 'package:flutter/material.dart';

class SalePage extends StatefulWidget {
  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Акции и предложения',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 36),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).secondaryHeaderColor, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                    """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non dictum felis. Suspendisse quis congue velit. Quisque vitae lacus fermentum, fringilla turpis nec, vestibulum ante. Phasellus sagittis pharetra tellus, vitae bibendum nisl vestibulum at. Etiam non nisi convallis, iaculis ante et, elementum est. Proin vel leo et est sodales accumsan. Ut interdum fringilla diam at tempus. Phasellus quis facilisis elit, a interdum velit. Duis id elementum tellus. Etiam pretium urna turpis. Pellentesque rutrum imperdiet cursus. Vestibulum vel luctus purus, eget semper leo.

Ut rutrum eu velit in ullamcorper. Nunc ullamcorper, ante eu posuere maximus, lectus nulla ullamcorper erat, vel pellentesque risus dui pharetra turpis. Fusce ornare ligula ac augue vehicula fermentum. Vivamus sed efficitur erat, non sodales sapien. Mauris sit amet ultricies tortor. Aliquam non egestas elit. Cras eu semper lectus, id feugiat diam.

Morbi commodo lacinia turpis. Praesent ut justo condimentum, accumsan dui eu, feugiat metus. Sed sagittis velit eget urna bibendum molestie. Nullam eu venenatis est. Fusce sit amet pulvinar ipsum. Nullam tempus tempor pellentesque. Donec sollicitudin vulputate nulla, sit amet tincidunt ipsum feugiat ut. Quisque volutpat, elit id pharetra laoreet, risus metus vehicula sapien, eget mattis nunc felis a sapien. Pellentesque maximus neque purus, in commodo augue rutrum egestas. Nunc eleifend et neque eu iaculis. Duis sodales libero at semper placerat. Vestibulum scelerisque felis eu massa cursus tempus. Aliquam vitae pharetra magna. Mauris mattis mi lacinia, pulvinar urna in, condimentum leo. Curabitur sit amet dui aliquam, malesuada turpis vel, mollis diam.

Nullam vitae maximus orci. Phasellus a pretium ex. Suspendisse egestas ac lectus nec ornare. Suspendisse varius dui ac semper laoreet. Morbi sem nibh, varius sit amet elit non, pretium tristique arcu. Maecenas condimentum iaculis lectus vel sagittis. Aenean sit amet leo eu ante euismod egestas elementum et eros. Nunc turpis erat, suscipit id sodales sit amet, convallis eu nisi. Donec vitae maximus leo. Vestibulum maximus purus vel felis tristique eleifend. Sed quis elit eget ex ultricies luctus. Proin egestas tempor est at tristique. Nam vulputate pulvinar viverra. Vivamus efficitur libero dapibus sagittis convallis. Nulla facilisi.

Proin suscipit laoreet lectus. Maecenas vitae nisl leo. Sed non lobortis augue, eu aliquam dui. Praesent posuere, neque et vulputate auctor, nisl ligula imperdiet libero, non pulvinar risus elit ut lectus. Suspendisse scelerisque a dui a interdum. Etiam at urna efficitur, posuere nunc vitae, fringilla lorem. Aliquam lobortis tristique justo, sit amet laoreet est venenatis vitae. Proin id imperdiet magna. Morbi porttitor nibh ac justo auctor, id imperdiet urna aliquet. Suspendisse potenti. Aliquam non risus justo. Quisque consectetur metus sit amet quam efficitur vulputate. Integer a diam est."""),
              ),
            )
          ],
        ),
      ),
    );
  }
}