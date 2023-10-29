public class Dog extends Pet{
    public Dog(String name, String date) {
        super(name, date);
    }

    @Override
    public String toString() {
        return "Dog {" +
                "name = '" + super.getName() + '\'' +
                ", commands = " + super.getCommands() +
                ", dateOfBirth = '" + super.getDateOfBirth() + '\'' +
                '}';
    }
}