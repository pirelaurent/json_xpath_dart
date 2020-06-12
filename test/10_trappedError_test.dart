import 'package:map_list_dot/map_list_dot_lib.dart';
import 'package:test/test.dart';

void main() {
  print(
      '------------------  These tests will write trapped errors on stdErr -------------');

  test('wrong json in constructor ', () {
    // dynamic root = MapList({"this": is not a[12] valid entry }); syntax error
    dynamic root = MapList('{"this": is not a[12] valid entry }');
    assert(root == null);
  });

  test(' common misuse of MapListDot ',(){
    dynamic root = MapList({"person":[{"name": "zaza"},{"name":"lulu"}]});
    assert(root.person[0].name == "zaza");
    print(root.person[0]["name"]);
    print(root.script('person[0]["name"]'));

  });



  test('wrong json in assignment  ', () {
    dynamic root = MapList({"name": "zaza"});
    root.name = [10,11,12,];
    root.script('name = [10,11,12,]');
    assert(root.name == null);
  });

  test('applying spurious index on a map  ', () {
    dynamic root = MapList({"name": "zaza", "age": 12});
    //root.name[toto]="riri"; // syntax error
    //root.name[0] = "lulu";  // syntax error
    root.script('name["toto"]="riri"');
    // ** bad index : name["toto"] . data unchanged. return null
    assert(root.name == "zaza");

    root.script('name[toto]="riri"');
    //** bad index : name[toto] . data unchanged. return null

    assert(root.name == "zaza");
    root.script('name[0]="lulu"');
    //** wrong index [0] in name[0] : not a List: data unchanged. return null
    assert(root.name == "zaza");
    print('---------------------------');
    root.script('name[toto].value =666') ;
    print(root);
    // same with trying to change a value
    // root.name[0] = "lulu"; cannot be done in code
    assert(root.name == "zaza");
  });


  test('applying spurious index on a map bis ', () {
    dynamic root = MapList({"name": "zaza", "age": 12});
    assert(root.name == "zaza");
    print('---------------------------');
    root.script(" [255] = 20");// well trapped : ** wrong index [255] in [255] : not a List: data unchanged. return null
// ci-dessous, ne sort pas d'erreur
    root.script(" '[255]' = 20");
    root.script('name[toto].value =666') ;
    // same with trying to change a value
    // root.name[0] = "lulu"; cannot be done in code
    assert(root.name == "zaza");
    root =MapList([1,2,3,4]);
    root.script(" [255] = 20");
    root.script(" '[255]' = 20");


  });
  test('trapp out of range in script ', () {
    dynamic root =MapList([0,1,2,3,4]);
    // calling a key on a list
    assert(root.script('price[200]') == null);

    assert(root.script('[2]') == 2);
    assert(root[2] == 2);

    assert(root[200] == null);
    assert(root.script('[200]') == null);

    dynamic book =MapList({ "name": "test", "price": [0,1,2,3,4]});
    assert(book.script('price[200]') == null);

  });
}