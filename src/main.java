//package 2026;

import javax.swing.*;
import java.awt.*;
public class main {

	public static void main(String[] args) {
		
		JLabel label = new JLabel("Hi, my name is Andrew, do you like math? (Answer Yes or No)");
		label.setFont(new Font("Arial", Font.PLAIN, 24));
		
		JPanel panel = new JPanel();
		panel.setPreferredSize(new Dimension(700,150));
		panel.add(label);
		
		String name = JOptionPane.showInputDialog(null, panel,"Hi, my name is Andrew, do you like math? (Answer Yes or No)",JOptionPane.PLAIN_MESSAGE);
		if(name.equalsIgnoreCase("Yes")) {
			label.setText("Good!, let's do some problems");
		}
		
		else if(name.equalsIgnoreCase("No")) {
				label.setText("Oh well, Let's do some problems anyways!");
		}
		
		
		label.setText("3x + 5 = 14    Find X");
		panel.setPreferredSize(new Dimension(700,200));
			name = JOptionPane.showInputDialog(null, panel, "3x + 5 = 14    Find X", JOptionPane.PLAIN_MESSAGE);
		
		if (name != null) {
			if(name.equals("3")) {
				label.setText("Correct! Thank you for cooperating in this small experiment!"); 
				JOptionPane.showMessageDialog(null,panel, "Correct!", JOptionPane.PLAIN_MESSAGE);
				
			}  
			else {
				panel.setPreferredSize(new Dimension(900,200));
				label.setText("Sorry, the answer is 3, but thank you for cooperating in this small experiment!");
			JOptionPane.showMessageDialog(null, panel,"Correct", JOptionPane.PLAIN_MESSAGE);
			}
		}
	}
}
