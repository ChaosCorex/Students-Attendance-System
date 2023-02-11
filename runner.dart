void main(List<String> args) {
  if (args.contains("--version")) {
    print("Welcome to Runner");
    print("####################################");

    print("Runner version is 1.2.45");

    print("####################################");
  }

  if (args.contains("doctor")) {
    print("Welcome to Runner");
    print("####################################");

    print("Will run doctor");

    print("####################################");
  }
}

int add(int x, int y) {
  return x + y;
}
