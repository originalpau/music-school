package model;

public class Student {
    private int student_id;
    private int count;

    public Student(int count, int student_id) {
        this.count = count;
        this.student_id = student_id;
    }

    public int getStudent_id() {
        return student_id;
    }

    public int getCount() {
        return count;
    }
}
