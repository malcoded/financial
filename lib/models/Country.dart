class Country {
  final String name;
  final String code;
  final String prefix;

  Country({required this.name, required this.code, required this.prefix});
}

final List<Country> latinAmericanCountries = [
  Country(name: "Argentina", code: "AR", prefix: "+54"),
  Country(name: "Bolivia", code: "BO", prefix: "+591"),
  Country(name: "Brasil", code: "BR", prefix: "+55"),
  Country(name: "Chile", code: "CL", prefix: "+56"),
  Country(name: "Colombia", code: "CO", prefix: "+57"),
  Country(name: "Costa Rica", code: "CR", prefix: "+506"),
  Country(name: "Cuba", code: "CU", prefix: "+53"),
  Country(name: "Ecuador", code: "EC", prefix: "+593"),
  Country(name: "El Salvador", code: "SV", prefix: "+503"),
  Country(name: "Guatemala", code: "GT", prefix: "+502"),
  Country(name: "Honduras", code: "HN", prefix: "+504"),
  Country(name: "México", code: "MX", prefix: "+52"),
  Country(name: "Nicaragua", code: "NI", prefix: "+505"),
  Country(name: "Panamá", code: "PA", prefix: "+507"),
  Country(name: "Paraguay", code: "PY", prefix: "+595"),
  Country(name: "Perú", code: "PE", prefix: "+51"),
  Country(name: "República Dominicana", code: "DO", prefix: "+1"),
  Country(name: "Uruguay", code: "UY", prefix: "+598"),
  Country(name: "Venezuela", code: "VE", prefix: "+58"),
];