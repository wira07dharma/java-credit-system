/*
 * CashierLoginDialog.java
 *
 * Created on December 17, 2004, 9:48 AM
 */

package com.dimata.pos.cashier;

import com.dimata.util.Formater;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.Timer;

import java.awt.Frame;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.util.Date;
/**
 *
 * @author  wpradnyana
 */
public class CashierLoginDialog extends JDialog {
    
    /** Creates new form CashierLoginDialog */
    
    public CashierLoginDialog(Frame parent, boolean modal) {
        super(parent, modal);
        initComponents();
        
        /**
         *  added for refreshing the time label
         */
        
        ActionListener taskPerformer = new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                refreshDate();
            }
        };
        new Timer(1000,taskPerformer).start();
        
        
        
        Date date = new Date();
        String tanggal = Formater.formatDate(date,"EEEE, dd MMM yyyy, h:mm:ss a");//Formater.FORMAT_DATE_SHORT_EUROPE);
        jLabel6.setText(tanggal);
        
        
    }
    public void initAllFields(){
        uPasswordField.setText("");
        userNameTextField.setText("");
    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        userNameTextField = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        uPasswordField = new javax.swing.JPasswordField();
        okLoginButton = new javax.swing.JButton();
        cancelLoginButton = new javax.swing.JButton();
        jPanel3 = new javax.swing.JPanel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Login");
        addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                formKeyPressed(evt);
            }
        });
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowActivated(java.awt.event.WindowEvent evt) {
                formWindowActivated(evt);
            }
            public void windowOpened(java.awt.event.WindowEvent evt) {
                formWindowOpened(evt);
            }
        });

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/company.gif")));
        jLabel1.setText(" ");
        jPanel1.add(jLabel1);

        getContentPane().add(jPanel1, java.awt.BorderLayout.NORTH);

        jPanel2.setLayout(new java.awt.GridBagLayout());

        jPanel2.setBorder(new javax.swing.border.TitledBorder("Login Form"));
        jLabel3.setText("Username");
        jPanel2.add(jLabel3, new java.awt.GridBagConstraints());

        userNameTextField.setColumns(10);
        userNameTextField.setHorizontalAlignment(javax.swing.JTextField.LEFT);
        userNameTextField.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                userNameTextFieldActionPerformed(evt);
            }
        });
        userNameTextField.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                userNameTextFieldFocusGained(evt);
            }
        });
        userNameTextField.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                userNameTextFieldKeyPressed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.insets = new java.awt.Insets(2, 2, 2, 2);
        jPanel2.add(userNameTextField, gridBagConstraints);

        jLabel4.setText("Password");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        jPanel2.add(jLabel4, gridBagConstraints);

        uPasswordField.setColumns(10);
        uPasswordField.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                uPasswordFieldActionPerformed(evt);
            }
        });
        uPasswordField.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                uPasswordFieldFocusGained(evt);
            }
        });
        uPasswordField.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                uPasswordFieldKeyPressed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.insets = new java.awt.Insets(2, 2, 2, 2);
        jPanel2.add(uPasswordField, gridBagConstraints);

        okLoginButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/BtnSave.jpg")));
        okLoginButton.setText("OK");
        okLoginButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                okLoginButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.insets = new java.awt.Insets(2, 2, 2, 2);
        jPanel2.add(okLoginButton, gridBagConstraints);

        cancelLoginButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/BtnCancel.jpg")));
        cancelLoginButton.setText("Cancel");
        cancelLoginButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cancelLoginButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.insets = new java.awt.Insets(2, 2, 2, 2);
        jPanel2.add(cancelLoginButton, gridBagConstraints);

        getContentPane().add(jPanel2, java.awt.BorderLayout.CENTER);

        jLabel5.setText("Date:");
        jPanel3.add(jLabel5);

        jLabel6.setText("Monday, 27 December 2004, 11:13:00 AM");
        jPanel3.add(jLabel6);

        getContentPane().add(jPanel3, java.awt.BorderLayout.SOUTH);

        pack();
    }//GEN-END:initComponents
    
    private void formKeyPressed (java.awt.event.KeyEvent evt)//GEN-FIRST:event_formKeyPressed
    {//GEN-HEADEREND:event_formKeyPressed
        // TODO add your handling code here:
        
    }//GEN-LAST:event_formKeyPressed
    
    private void formWindowActivated (java.awt.event.WindowEvent evt)//GEN-FIRST:event_formWindowActivated
    {//GEN-HEADEREND:event_formWindowActivated
        // TODO add your handling code here:
        userNameTextField.requestFocusInWindow();
    }//GEN-LAST:event_formWindowActivated
    
    private void uPasswordFieldKeyPressed (java.awt.event.KeyEvent evt)//GEN-FIRST:event_uPasswordFieldKeyPressed
    {//GEN-HEADEREND:event_uPasswordFieldKeyPressed
        // TODO add your handling code here:
        if(evt.getKeyCode()==KeyEvent.VK_ESCAPE){
            userNameTextField.requestFocusInWindow();
        }
    }//GEN-LAST:event_uPasswordFieldKeyPressed
    
    private void userNameTextFieldKeyPressed (java.awt.event.KeyEvent evt)//GEN-FIRST:event_userNameTextFieldKeyPressed
    {//GEN-HEADEREND:event_userNameTextFieldKeyPressed
        // TODO add your handling code here:
        if(evt.getKeyCode()==KeyEvent.VK_ESCAPE){
            this.hide();
        }
    }//GEN-LAST:event_userNameTextFieldKeyPressed
    
    private void formWindowOpened (java.awt.event.WindowEvent evt)//GEN-FIRST:event_formWindowOpened
    {//GEN-HEADEREND:event_formWindowOpened
        // TODO add your handling code here:
        userNameTextField.setText("");
        uPasswordField.setText("");
        userNameTextField.requestFocusInWindow();
    }//GEN-LAST:event_formWindowOpened
    
    private void uPasswordFieldFocusGained (java.awt.event.FocusEvent evt)//GEN-FIRST:event_uPasswordFieldFocusGained
    {//GEN-HEADEREND:event_uPasswordFieldFocusGained
        // TODO add your handling code here:
        uPasswordField.selectAll();
    }//GEN-LAST:event_uPasswordFieldFocusGained
    
    private void userNameTextFieldFocusGained (java.awt.event.FocusEvent evt)//GEN-FIRST:event_userNameTextFieldFocusGained
    {//GEN-HEADEREND:event_userNameTextFieldFocusGained
        // TODO add your handling code here:
        userNameTextField.selectAll();
    }//GEN-LAST:event_userNameTextFieldFocusGained
    
    private void cancelLoginButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_cancelLoginButtonActionPerformed
        // TODO add your handling code here:
        cmdCancelLogin();
    }//GEN-LAST:event_cancelLoginButtonActionPerformed
    
    private void okLoginButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_okLoginButtonActionPerformed
        // TODO add your handling code here:
        doLogin();
    }//GEN-LAST:event_okLoginButtonActionPerformed
    
    private void uPasswordFieldActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_uPasswordFieldActionPerformed
        // TODO add your handling code here:
        //okLoginButton.requestFocusInWindow();
        doLogin();
    }//GEN-LAST:event_uPasswordFieldActionPerformed
    public void doLogin(){
        SessionManager.setUserName(userNameTextField.getText());
        //System.out.println(" username ="+userNameTextField.getText());
        SessionManager.setUserPwd(String.valueOf(uPasswordField.getPassword()));
        //System.out.println(" password ="+String.valueOf(uPasswordField.getPassword()));
        boolean isSuccess = CashierMainApp.loginTrigger();
        if(!isSuccess){
            JOptionPane.showMessageDialog(this,"Login failed","Login Failed",JOptionPane.ERROR_MESSAGE);
            userNameTextField.requestFocusInWindow();
        }
        
    }
    public void cmdCancelLogin(){
        
        //JOptionPane.showMessageDialog(this,"Cancel Login","login",JOptionPane.OK_OPTION);
        //Cashier
        this.dispose();
        
    }
    private void userNameTextFieldActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_userNameTextFieldActionPerformed
        // TODO add your handling code here:
        uPasswordField.requestFocusInWindow();
    }//GEN-LAST:event_userNameTextFieldActionPerformed
    
    private void refreshDate(){
        Date date = new Date();
        String tanggal = Formater.formatDate(date,"EEEE, dd MMM yyyy, h:mm:ss a");//Formater.FORMAT_DATE_SHORT_EUROPE);
        jLabel6.setText(tanggal);
        jLabel6.validate();
    }
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        new CashierLoginDialog(new JFrame(), true).show();
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton cancelLoginButton;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JButton okLoginButton;
    private javax.swing.JPasswordField uPasswordField;
    private javax.swing.JTextField userNameTextField;
    // End of variables declaration//GEN-END:variables
    
}
