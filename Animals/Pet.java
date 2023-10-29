public class Pet extends Animal{
    public Pet(String name, String date) {
        super(name, date);
    }

    @Override
    public String toString() {
        return "Pet {" +
                "name = '" + super.getName() + '\'' +
                ", commands = " + super.getCommands() +
                ", dateOfBirth = '" + super.getDateOfBirth() + '\'' +
                '}';
    }
}