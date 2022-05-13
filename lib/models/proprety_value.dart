class PropretyValue {
  String? name;
  String? area; //change to double once form works
  double? value;

  PropretyValue( this.name, this.area, this.value);

  get getName => name;

  set setName(name) => this.name = name;

  get getArea => area;

  set setArea(area) => this.area = area;

  get getValue => value;

  set setValue(value) => this.value = value;
}