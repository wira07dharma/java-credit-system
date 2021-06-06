/*
 * CashierMainFrame.java
 *
 * Created on December 4, 2004, 6:56 AM
 */

package com.dimata.pos.cashier;

import java.awt.Dimension;
import java.awt.EventQueue;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import com.dimata.posbo.entity.transferdata.SrcTransferData;

/**
 *
 * @author  Widi Pradnyana
 */
public class CashierMainFrame extends JFrame {
    
    
    /** Creates new form CashierMainFrame */
    public CashierMainFrame() {
        
        initComponents();
        
        pendingOrderButton.setVisible(CashierMainApp.isEnablePendingOrder());
        pendingOrderMenuItem.setVisible(CashierMainApp.isEnablePendingOrder());
        creditPaymentButton.setVisible(CashierMainApp.isEnableCreditPayment());
        creditPaymentMenuItem.setVisible(CashierMainApp.isEnableCreditPayment());
        giftButton.setVisible(CashierMainApp.isEnableGiftTrans()); 
        giftMenuItem.setVisible(CashierMainApp.isEnableGiftTrans());
        rateButton.setVisible(CashierMainApp.isEnableRateUpdate());
        
        initAllFields();
        
    }
    public void initAllFields(){
        
        cashSaleButton.setMnemonic('I');
        pendingOrderButton.setMnemonic('P');
        giftButton.setMnemonic('G');
        creditPaymentButton.setMnemonic('C');
        systemMenu.setMnemonic('S');
        transactionMenu.setMnemonic('T');
        reportMenu.setMnemonic('R');
        helpMenu.setMnemonic('H');
        dataMenu.setMnemonic('D');
        logoutButton.setMnemonic('L');
        
        if(CashierMainApp.isAnyUser()){
            logoutMenuItem.setEnabled(true);
        }else{
            logoutMenuItem.setEnabled(false);
        }
        if(CashierMainApp.isAnyCashier()){
            cashSaleButton.setEnabled(true);
            logoutButton.setEnabled(true);
            logoutMenuItem.setEnabled(true);
            loginMenuItem.setEnabled(false);
            pendingOrderButton.setEnabled(true);
            giftButton.setEnabled(true);
            cashSaleMenuItem.setEnabled(true);
            pendingOrderMenuItem.setEnabled(true);
            giftMenuItem.setEnabled(true);
            cashBalMenuItem.setEnabled(true);
            currentBalMenuItem.setEnabled(true);
            creditPaymentButton.setEnabled(true);
            creditPaymentMenuItem.setEnabled(true);
            rateButton.setEnabled(true);
        }else{
            cashSaleButton.setEnabled(false);
            logoutButton.setEnabled(false);
            logoutMenuItem.setEnabled(false);
            loginMenuItem.setEnabled(true);
            pendingOrderButton.setEnabled(false);
            giftButton.setEnabled(false);
            cashSaleMenuItem.setEnabled(false);
            pendingOrderMenuItem.setEnabled(false);
            giftMenuItem.setEnabled(false);
            cashBalMenuItem.setEnabled(false);
            currentBalMenuItem.setEnabled(false);
            creditPaymentButton.setEnabled(false);
            creditPaymentMenuItem.setEnabled(false);
            rateButton.setEnabled(false);
        }
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    
    private void initComponents() {//GEN-BEGIN:initComponents
        currentBalMenuItem = new javax.swing.JMenuItem();
        cashBalMenuItem = new javax.swing.JMenuItem();
        reportMenu = new javax.swing.JMenu();
        jPanel1 = new javax.swing.JPanel();
        jToolBar1 = new javax.swing.JToolBar();
        cashSaleButton = new javax.swing.JButton();
        pendingOrderButton = new javax.swing.JButton();
        giftButton = new javax.swing.JButton();
        creditPaymentButton = new javax.swing.JButton();
        rateButton = new javax.swing.JButton();
        jToolBar2 = new javax.swing.JToolBar();
        logoutButton = new javax.swing.JButton();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jDesktopPane1 = new javax.swing.JDesktopPane();
        jMenuBar1 = new javax.swing.JMenuBar();
        systemMenu = new javax.swing.JMenu();
        logoutMenuItem = new javax.swing.JMenuItem();
        loginMenuItem = new javax.swing.JMenuItem();
        exitMenuItem = new javax.swing.JMenuItem();
        transactionMenu = new javax.swing.JMenu();
        cashSaleMenuItem = new javax.swing.JMenuItem();
        pendingOrderMenuItem = new javax.swing.JMenuItem();
        giftMenuItem = new javax.swing.JMenuItem();
        creditPaymentMenuItem = new javax.swing.JMenuItem();
        dataMenu = new javax.swing.JMenu();
        tranferMenu = new javax.swing.JMenu();
        allTransMenu = new javax.swing.JMenuItem();
        allMasterMenu = new javax.swing.JMenuItem();
        allCatalogMenu = new javax.swing.JMenuItem();
        masterMenu = new javax.swing.JMenuItem();
        restoreMenu = new javax.swing.JMenu();
        allMenuRestore = new javax.swing.JMenuItem();
        masterMenuRestore = new javax.swing.JMenuItem();
        prochainTransMenu = new javax.swing.JMenu();
        allMenuItem = new javax.swing.JMenuItem();
        byCodeMenuItem = new javax.swing.JMenuItem();
        ftpSynchMenu = new javax.swing.JMenu();
        connMenuItem = new javax.swing.JMenuItem();
        logMenuItem = new javax.swing.JMenuItem();
        helpMenu = new javax.swing.JMenu();
        aboutMenuItem = new javax.swing.JMenuItem();

        currentBalMenuItem.setText("Current Balance");
        cashBalMenuItem.setText("Opening Balance");
        cashBalMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cashBalMenuItemActionPerformed(evt);
            }
        });

        reportMenu.setText("Report");

        setDefaultCloseOperation(javax.swing.WindowConstants.DO_NOTHING_ON_CLOSE);
        setTitle("Cashier");
        addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                formFocusGained(evt);
            }
        });
        addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                formKeyPressed(evt);
            }
        });

        jPanel1.setLayout(new java.awt.FlowLayout(java.awt.FlowLayout.LEFT));

        cashSaleButton.setText("New Invoice (Alt+I)");
        cashSaleButton.setBorder(new javax.swing.border.SoftBevelBorder(javax.swing.border.BevelBorder.RAISED));
        cashSaleButton.setEnabled(false);
        cashSaleButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cashSaleButtonActionPerformed(evt);
            }
        });

        jToolBar1.add(cashSaleButton);

        pendingOrderButton.setText("New Pending Order (Alt+P)");
        pendingOrderButton.setBorder(new javax.swing.border.SoftBevelBorder(javax.swing.border.BevelBorder.RAISED));
        pendingOrderButton.setEnabled(false);
        pendingOrderButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                pendingOrderButtonActionPerformed(evt);
            }
        });

        jToolBar1.add(pendingOrderButton);

        giftButton.setText("New Gift (Alt+G)");
        giftButton.setBorder(new javax.swing.border.SoftBevelBorder(javax.swing.border.BevelBorder.RAISED));
        giftButton.setEnabled(false);
        giftButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                giftButtonActionPerformed(evt);
            }
        });

        jToolBar1.add(giftButton);

        creditPaymentButton.setText("Credit Payment (Alt+C)");
        creditPaymentButton.setBorder(new javax.swing.border.SoftBevelBorder(javax.swing.border.BevelBorder.RAISED));
        creditPaymentButton.setEnabled(false);
        creditPaymentButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                creditPaymentButtonActionPerformed(evt);
            }
        });

        jToolBar1.add(creditPaymentButton);

        rateButton.setMnemonic('R');
        rateButton.setText("Exchange Rate (Alt+R)");
        rateButton.setBorder(new javax.swing.border.SoftBevelBorder(javax.swing.border.BevelBorder.RAISED));
        rateButton.setEnabled(false);
        rateButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                rateButtonActionPerformed(evt);
            }
        });

        jToolBar1.add(rateButton);

        jPanel1.add(jToolBar1);

        logoutButton.setMnemonic('L');
        logoutButton.setText("Logout (Alt+L)");
        logoutButton.setBorder(new javax.swing.border.SoftBevelBorder(javax.swing.border.BevelBorder.RAISED));
        logoutButton.setEnabled(false);
        logoutButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                logoutButtonActionPerformed(evt);
            }
        });

        jToolBar2.add(logoutButton);

        jPanel1.add(jToolBar2);

        getContentPane().add(jPanel1, java.awt.BorderLayout.NORTH);

        jPanel2.setLayout(new java.awt.BorderLayout());

        jPanel2.setDoubleBuffered(false);
        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        jDesktopPane1.setPreferredSize(new java.awt.Dimension(800, 600));
        jDesktopPane1.setAutoscrolls(true);
        jScrollPane1.setViewportView(jDesktopPane1);

        jPanel2.add(jScrollPane1, java.awt.BorderLayout.CENTER);

        getContentPane().add(jPanel2, java.awt.BorderLayout.CENTER);

        systemMenu.setText("System");
        logoutMenuItem.setText("Logout");
        logoutMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                logoutMenuItemActionPerformed(evt);
            }
        });

        systemMenu.add(logoutMenuItem);

        loginMenuItem.setText("Login");
        loginMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                loginMenuItemActionPerformed(evt);
            }
        });

        systemMenu.add(loginMenuItem);

        exitMenuItem.setText("Exit");
        exitMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitMenuItemActionPerformed(evt);
            }
        });

        systemMenu.add(exitMenuItem);

        jMenuBar1.add(systemMenu);

        transactionMenu.setText("Transactions");
        cashSaleMenuItem.setText("Invoice");
        cashSaleMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cashSaleMenuItemActionPerformed(evt);
            }
        });

        transactionMenu.add(cashSaleMenuItem);

        pendingOrderMenuItem.setText("Pending Order");
        pendingOrderMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                pendingOrderMenuItemActionPerformed(evt);
            }
        });

        transactionMenu.add(pendingOrderMenuItem);

        giftMenuItem.setText("Gift");
        giftMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                giftMenuItemActionPerformed(evt);
            }
        });

        transactionMenu.add(giftMenuItem);

        creditPaymentMenuItem.setText("Credit Payment");
        creditPaymentMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                creditPaymentMenuItemActionPerformed(evt);
            }
        });

        transactionMenu.add(creditPaymentMenuItem);

        jMenuBar1.add(transactionMenu);

        dataMenu.setText("Data");
        tranferMenu.setText("Transfer");
        allTransMenu.setText("All Transaction");
        allTransMenu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                allTransMenuActionPerformed(evt);
            }
        });

        tranferMenu.add(allTransMenu);

        allMasterMenu.setText("All Master Data");
        allMasterMenu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                allMasterMenuActionPerformed(evt);
            }
        });

        tranferMenu.add(allMasterMenu);

        allCatalogMenu.setText("All Data Catalog");
        allCatalogMenu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                allCatalogMenuActionPerformed(evt);
            }
        });

        tranferMenu.add(allCatalogMenu);

        masterMenu.setText("Master Catalog by Date");
        masterMenu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                masterMenuActionPerformed(evt);
            }
        });

        tranferMenu.add(masterMenu);

        dataMenu.add(tranferMenu);

        restoreMenu.setText("Restore");
        allMenuRestore.setText("All Data");
        allMenuRestore.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                allMenuRestoreActionPerformed(evt);
            }
        });

        restoreMenu.add(allMenuRestore);

        masterMenuRestore.setText("Master by Date");
        masterMenuRestore.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                masterMenuRestoreActionPerformed(evt);
            }
        });

        restoreMenu.add(masterMenuRestore);

        dataMenu.add(restoreMenu);

        prochainTransMenu.setText("Prochain Sync");
        allMenuItem.setText("All");
        allMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                allMenuItemActionPerformed(evt);
            }
        });

        prochainTransMenu.add(allMenuItem);

        byCodeMenuItem.setText("By Code");
        byCodeMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                byCodeMenuItemActionPerformed(evt);
            }
        });

        prochainTransMenu.add(byCodeMenuItem);

        dataMenu.add(prochainTransMenu);

        ftpSynchMenu.setText("FTP Synch");
        connMenuItem.setText("FTP Connection");
        connMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                connMenuItemActionPerformed(evt);
            }
        });

        ftpSynchMenu.add(connMenuItem);

        logMenuItem.setText("FTP Transfer Logs");
        logMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                logMenuItemActionPerformed(evt);
            }
        });

        ftpSynchMenu.add(logMenuItem);

        dataMenu.add(ftpSynchMenu);

        jMenuBar1.add(dataMenu);

        helpMenu.setText("Help");
        aboutMenuItem.setText("About");
        aboutMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                aboutMenuItemActionPerformed(evt);
            }
        });

        helpMenu.add(aboutMenuItem);

        jMenuBar1.add(helpMenu);

        setJMenuBar(jMenuBar1);

        pack();
    }//GEN-END:initComponents

    private void logMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_logMenuItemActionPerformed
        LogDialog frame = new LogDialog(this,true,CashSaleController.getFtpLogs());
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame));
        frame.show();
    }//GEN-LAST:event_logMenuItemActionPerformed

    private void connMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_connMenuItemActionPerformed
        FtpConfigDialog frame = new FtpConfigDialog(this,true);
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame));
        frame.show();
    }//GEN-LAST:event_connMenuItemActionPerformed

    private void byCodeMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_byCodeMenuItemActionPerformed
        //ProchainTransferCatalogDialog frame = new ProchainTransferCatalogDialog(this,true);
        //frame.setLocation(CashSaleController.getCenterScreenPoint(frame));
        //frame.show();
    }//GEN-LAST:event_byCodeMenuItemActionPerformed

    private void allMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_allMenuItemActionPerformed
        //ProchainTransferAllDialog frame = new ProchainTransferAllDialog(this,true);
        //frame.setLocation(CashSaleController.getCenterScreenPoint(frame));
        //frame.show();
    }//GEN-LAST:event_allMenuItemActionPerformed

    private void rateButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_rateButtonActionPerformed
        CashRateDialog frame = new CashRateDialog(this,true);
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame));
        frame.show();
    }//GEN-LAST:event_rateButtonActionPerformed

    private void allCatalogMenuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_allCatalogMenuActionPerformed
       TransferAllData frame =  new TransferAllData(this,true,SrcTransferData.CATALOG_TO_CASHIER);
        frame.setSize(350,150);
        frame.setModal(true); 
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame)); 
        frame.show();
    }//GEN-LAST:event_allCatalogMenuActionPerformed

    private void allMasterMenuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_allMasterMenuActionPerformed
        TransferAllData frame =  new TransferAllData(this,true,SrcTransferData.TO_CASHIER_OUTLET);
        frame.setSize(350,150);
        frame.setModal(true); 
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame)); 
        frame.show(); 
    }//GEN-LAST:event_allMasterMenuActionPerformed
    
    private void masterMenuRestoreActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_masterMenuRestoreActionPerformed
        RestoreMasterdata frame = new RestoreMasterdata(this,true);
        frame.setModal(true); 
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame)); 
        frame.show();
    }//GEN-LAST:event_masterMenuRestoreActionPerformed
    
    private void allMenuRestoreActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_allMenuRestoreActionPerformed
        RestoreAllData frame = new RestoreAllData(this,true);
        frame.setModal(true); 
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame)); 
        frame.show();
    }//GEN-LAST:event_allMenuRestoreActionPerformed
    
    private void masterMenuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_masterMenuActionPerformed
        TransferMasterdata frame =   new TransferMasterdata(this,true);
        frame.setSize(600,100);
        frame.setModal(true); 
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame)); 
        frame.show();
    }//GEN-LAST:event_masterMenuActionPerformed
        
    private void allTransMenuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_allTransMenuActionPerformed
        TransferAllData frame =  new TransferAllData(this,true,SrcTransferData.FROM_CASHIER_OUTLET);
        frame.setSize(350,150);
        frame.setModal(true); 
        frame.setLocation(CashSaleController.getCenterScreenPoint(frame)); 
        frame.show(); 
    }//GEN-LAST:event_allTransMenuActionPerformed
        
    private void creditPaymentButtonActionPerformed (java.awt.event.ActionEvent evt)//GEN-FIRST:event_creditPaymentButtonActionPerformed
    {//GEN-HEADEREND:event_creditPaymentButtonActionPerformed
        // TODO add your handling code here:
        cmdNewCreditPayment();
    }//GEN-LAST:event_creditPaymentButtonActionPerformed
    
    private void creditPaymentMenuItemActionPerformed (java.awt.event.ActionEvent evt)//GEN-FIRST:event_creditPaymentMenuItemActionPerformed
    {//GEN-HEADEREND:event_creditPaymentMenuItemActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_creditPaymentMenuItemActionPerformed
    
    public void cmdNewCreditPayment(){
        
        if(CashierMainApp.isAnyCashier()){
            this.getCreditPaymentDialog();
            creditPaymentDialog.cmdNewTrans();
            creditPaymentDialog.show();
            creditPaymentDialog.requestFocus();
            
        }else{
            cmdRequestLogin();
            
        }
        
    }
    private CreditPaymentDialog creditPaymentDialog;
    private void formFocusGained (java.awt.event.FocusEvent evt)//GEN-FIRST:event_formFocusGained
    {//GEN-HEADEREND:event_formFocusGained
        // TODO add your handling code here:
        initAllFields();
    }//GEN-LAST:event_formFocusGained
    
    private void exitMenuItemActionPerformed (java.awt.event.ActionEvent evt)//GEN-FIRST:event_exitMenuItemActionPerformed
    {//GEN-HEADEREND:event_exitMenuItemActionPerformed
        // TODO add your handling code here:
        cmdRequestExit();
    }//GEN-LAST:event_exitMenuItemActionPerformed
    
    private void loginMenuItemActionPerformed (java.awt.event.ActionEvent evt)//GEN-FIRST:event_loginMenuItemActionPerformed
    {//GEN-HEADEREND:event_loginMenuItemActionPerformed
        // TODO add your handling code here:
        cmdRequestLogin();
    }//GEN-LAST:event_loginMenuItemActionPerformed
    
    private void formKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_formKeyPressed
        // TODO add your handling code here:
        
    }//GEN-LAST:event_formKeyPressed
    private CashSaleFrame cashSaleFrame = null;
    
    /*private static CreditSalesSearch creditSaleSearch = null;
    private static MemberSearch memberSearch = null;
    private static OpenBillSearch openBillSearch = null;
    private static PendingOrderSearch pendOrderSearch = null;
    private static ProductSearch productSearch = null;
    private static PaymentFrame paymentFrame = null;
     */
    private void logoutButtonActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_logoutButtonActionPerformed
        // TODO add your handling code here:
        cmdRequestLogout();
        
    }//GEN-LAST:event_logoutButtonActionPerformed
    
    private void giftButtonActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_giftButtonActionPerformed
        // TODO add your handling code here:
        cmdNewGift();
        
    }//GEN-LAST:event_giftButtonActionPerformed
    
    private void pendingOrderButtonActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_pendingOrderButtonActionPerformed
        // TODO add your handling code here:
        cmdNewPendingOrder();
        
        
    }//GEN-LAST:event_pendingOrderButtonActionPerformed
    
    private void cashSaleButtonActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_cashSaleButtonActionPerformed
        // TODO add your handling code here:
        cmdNewSale();
        
    }//GEN-LAST:event_cashSaleButtonActionPerformed
    
    private void aboutMenuItemActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_aboutMenuItemActionPerformed
        // TODO add your handling code here:
        JOptionPane.showMessageDialog(this,"Dimata Cashier v.2 ","About",JOptionPane.INFORMATION_MESSAGE);
        
    }//GEN-LAST:event_aboutMenuItemActionPerformed
    
    private void cashBalMenuItemActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_cashBalMenuItemActionPerformed
        // TODO add your handling code here:
        cmdShowCashBalance();
        
    }//GEN-LAST:event_cashBalMenuItemActionPerformed
    
    private void cmdShowCashBalance(){
        //if(!CashierMainApp.isAnyCashier ()){
        //    CashierMainApp.activateLoginDialog ();
        //}else{
        //CashierMainApp.activateBalanceDialog ();
        //}
    }
    private void giftMenuItemActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_giftMenuItemActionPerformed
        // TODO add your handling code here:
        cmdNewGift();
        
    }//GEN-LAST:event_giftMenuItemActionPerformed
    
    private void pendingOrderMenuItemActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_pendingOrderMenuItemActionPerformed
        // TODO add your handling code here:
        cmdNewPendingOrder();
        
    }//GEN-LAST:event_pendingOrderMenuItemActionPerformed
    
    private void cashSaleMenuItemActionPerformed(java.awt.event.ActionEvent evt) {
        
//GEN-FIRST:event_cashSaleMenuItemActionPerformed
        // TODO add your handling code here:
        cmdNewSale();
        
    }//GEN-LAST:event_cashSaleMenuItemActionPerformed
    
    private void logoutMenuItemActionPerformed(java.awt.event.ActionEvent evt) {
        
        
//GEN-FIRST:event_logoutMenuItemActionPerformed
        // TODO add your handling code here:
        cmdRequestLogout();
        
    }//GEN-LAST:event_logoutMenuItemActionPerformed
    
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                
                new CashierMainFrame().setVisible(true);
                
            }
        });
        
    }
    
    public CashSaleFrame getCashSaleFrame() {
        
        if(cashSaleFrame==null){
            cashSaleFrame = new CashSaleFrame(this,true);
            cashSaleFrame.setModal(true);
            
            Dimension dim = new Dimension();
            dim = cashSaleFrame.getContentPane().getToolkit().getScreenSize();
            int w = dim.width;      // maxscreenSize
            int h = dim.height;     // max screenSize
            //if(w>801){
            cashSaleFrame.setBounds(0,0, w,h);
            //}
            cashSaleFrame.setLocation(CashSaleController.getCenterScreenPoint(cashSaleFrame));
            
        }
        
        return cashSaleFrame;
    }
    
    public void setCashSaleFrame(CashSaleFrame cashSaleFrame) {
        
        this.cashSaleFrame = cashSaleFrame;
        
    }
    
    public void cmdNewSale(){
        
        if(CashierMainApp.isAnyCashier()){
            this.getCashSaleFrame();
            
            //cashSaleFrame.initAllFields();
            cashSaleFrame.cmdNewSales();
            cashSaleFrame.show();
            
        }else{
            cmdRequestLogin();
            
        }
        
    }
    
    public void cmdNewPendingOrder(){
        
        if(CashierMainApp.isAnyCashier()){
            this.getPendingOrderFrame();
            pendingOrderFrame.initAllFields();
            pendingOrderFrame.show();
            //pendingOrderFrame.requestFocus();
        }else{
            cmdRequestLogin();
            
        }
        
    }
    
    public void cmdNewGift(){
        
        if(CashierMainApp.isAnyCashier()){
            
            this.getGiftFrame();
            giftFrame.cmdNewGiftTrans();
            giftFrame.show();
            //giftFrame.requestFocus();
            
        }else{
            cmdRequestLogin();
            
        }
        
    }
    private void cmdLogout(){
        
    }
    
    /**
     * Getter for property pendingOrderFrame.
     * @return Value of property pendingOrderFrame.
     */
    public com.dimata.pos.cashier.PendingOrderFrame getPendingOrderFrame() {
        
        if(pendingOrderFrame==null){
            pendingOrderFrame = new PendingOrderFrame(this,true);
            pendingOrderFrame.setModal(true);
            Dimension dim = new Dimension();
            pendingOrderFrame.getSize();
            dim = pendingOrderFrame.getSize();
            //dim = pendingOrderFrame.getContentPane().getToolkit().getScreenSize();
            int w = dim.width;//*3/4;      // maxscreenSize
            int h = dim.height;//*3/4;     // max screenSize
            pendingOrderFrame.setBounds(0,0, w,h);
            pendingOrderFrame.setLocation(CashSaleController.getCenterScreenPoint(pendingOrderFrame));
            //this.jDesktopPane1.add(pendingOrderFrame);
        }
        
        return pendingOrderFrame;
    }
    
    /**
     * Setter for property pendingOrderFrame.
     * @param pendingOrderFrame New value of property pendingOrderFrame.
     */
    public void setPendingOrderFrame(com.dimata.pos.cashier.PendingOrderFrame pendingOrderFrame) {
        
        this.pendingOrderFrame = pendingOrderFrame;
        
    }
    
    /**
     * Getter for property giftFrame.
     * @return Value of property giftFrame.
     */
    public com.dimata.pos.cashier.GiftFrame getGiftFrame() {
        
        if(giftFrame==null){
            giftFrame = new GiftFrame(this,true);
            //this.jDesktopPane1.add(giftFrame);
            Dimension dim = giftFrame.getSize();
            int w = dim.width;//*3/4;      // maxscreenSize
            int h = dim.height;//*3/4;     // max screenSize
            //giftFrame.setBounds(0,0, w,h);
            giftFrame.setLocation(CashSaleController.getCenterScreenPoint(giftFrame));
        }
        
        return giftFrame;
    }
    
    /**
     * Setter for property giftFrame.
     * @param giftFrame New value of property giftFrame.
     */
    public void setGiftFrame(com.dimata.pos.cashier.GiftFrame giftFrame) {
        
        this.giftFrame = giftFrame;
        
    }
    
    
    private boolean cmdCloseAllTransacttion(){
        if(this.getCashSaleFrame().isEnabled()){
            this.getCashSaleFrame().cmdCloseWindows();
        }
        if(this.getPendingOrderFrame().isEnabled()){
            //this.getPendingOrderFrame ().
        }
        if(this.getGiftFrame().isEnabled()){
            //this.getGiftFrame ().cm
        }
        boolean closedAll = true;
        return closedAll;
    }
    private void cmdRequestLogin(){
        
        if(CashierMainApp.getCashUser()!=null){
            //cmdRequestLogout ();
        }else{
            CashierMainApp.activateLoginDialog();
        }
    }
    
    
    private void cmdRequestLogout(){
        boolean saleClosed = false;
        boolean pendingOrderClosed = false;
        boolean giftClosed = false;
        boolean creditClosed = false;
        //if(this.cashSaleFrame!=null){
        //if(!this.getCashSaleFrame ().isSelected ()&&!this.getCashSaleFrame ().isVisible ()){
        if(!this.getCashSaleFrame().isShowing()&&!this.getCashSaleFrame().isVisible()){
            //if(this.getCashSaleFrame ().cmdCloseWindows ()){
            saleClosed = true;
            //}
        }
        //if(this.pendingOrderFrame!=null ){
        if(!this.getPendingOrderFrame().isShowing()&&!this.getPendingOrderFrame().isVisible()){
            //if(this.getPendingOrderFrame().cmdCloseWindows ()){
            pendingOrderClosed = true;
            //}
        }
        //if(this.giftFrame !=null){
        if(!this.getGiftFrame().isShowing()&&!this.getGiftFrame().isVisible()){
            //if(this.getGiftFrame().cmdCloseWindows ()){
            giftClosed = true;
            //}
        }
        if(!this.getCreditPaymentDialog().isShowing()&&!this.getCreditPaymentDialog().isVisible()){
            //if(this.getGiftFrame().cmdCloseWindows ()){
            creditClosed = true;
            //}
        }
        
        if(saleClosed&&pendingOrderClosed&&giftClosed&&creditClosed){
            //this.dispose();
            CashierMainApp.logoutTrigger();
        }else{
            JOptionPane.showMessageDialog(this," Close all transaction first","Confirm Close",JOptionPane.WARNING_MESSAGE);
        }
       /*CashierMainApp.setCashUser (null);
       CashierMainApp.activateLoginDialog ();
        */
    }
    
    private void cmdRequestExit(){
        //cmdRequestLogout ();
        if(CashierMainApp.isAnyCashier()&&CashierMainApp.isAnyUser()){
            JOptionPane.showMessageDialog(this," Please logout first","Logout",JOptionPane.WARNING_MESSAGE);
        }else{
            JOptionPane.showMessageDialog(this," Thank you for using Dimata Cashier.","Logout",JOptionPane.PLAIN_MESSAGE);
            CashierMainApp.exitTrigger();
        }
        
    }
    
    /**
     * Getter for property creditPaymentDialog.
     * @return Value of property creditPaymentDialog.
     */
    public com.dimata.pos.cashier.CreditPaymentDialog getCreditPaymentDialog() {
        if(creditPaymentDialog==null){
            creditPaymentDialog = new CreditPaymentDialog(this,true);
            Dimension dim = creditPaymentDialog.getSize();
            int w = dim.width;//*3/4;      // maxscreenSize
            int h = dim.height;//*3/4;     // max screenSize
            creditPaymentDialog.setBounds(0,0, w,h);
            creditPaymentDialog.setLocation(CashSaleController.getCenterScreenPoint(creditPaymentDialog));
        }
        return creditPaymentDialog;
    }
    
    
    /**
     * Setter for property creditPaymentDialog.
     * @param creditPaymentDialog New value of property creditPaymentDialog.
     */
    public void setCreditPaymentDialog(com.dimata.pos.cashier.CreditPaymentDialog creditPaymentDialog) {
        this.creditPaymentDialog = creditPaymentDialog;
    }
    
    private PendingOrderFrame pendingOrderFrame = null;
    private GiftFrame giftFrame = null;
    
    /* method for transfer all */
    public void cmdAllTransfer(){
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenuItem aboutMenuItem;
    private javax.swing.JMenuItem allCatalogMenu;
    private javax.swing.JMenuItem allMasterMenu;
    private javax.swing.JMenuItem allMenuItem;
    private javax.swing.JMenuItem allMenuRestore;
    private javax.swing.JMenuItem allTransMenu;
    private javax.swing.JMenuItem byCodeMenuItem;
    private javax.swing.JMenuItem cashBalMenuItem;
    private javax.swing.JButton cashSaleButton;
    private javax.swing.JMenuItem cashSaleMenuItem;
    private javax.swing.JMenuItem connMenuItem;
    private javax.swing.JButton creditPaymentButton;
    private javax.swing.JMenuItem creditPaymentMenuItem;
    private javax.swing.JMenuItem currentBalMenuItem;
    private javax.swing.JMenu dataMenu;
    private javax.swing.JMenuItem exitMenuItem;
    private javax.swing.JMenu ftpSynchMenu;
    private javax.swing.JButton giftButton;
    private javax.swing.JMenuItem giftMenuItem;
    private javax.swing.JMenu helpMenu;
    private javax.swing.JDesktopPane jDesktopPane1;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JToolBar jToolBar1;
    private javax.swing.JToolBar jToolBar2;
    private javax.swing.JMenuItem logMenuItem;
    private javax.swing.JMenuItem loginMenuItem;
    private javax.swing.JButton logoutButton;
    private javax.swing.JMenuItem logoutMenuItem;
    private javax.swing.JMenuItem masterMenu;
    private javax.swing.JMenuItem masterMenuRestore;
    private javax.swing.JButton pendingOrderButton;
    private javax.swing.JMenuItem pendingOrderMenuItem;
    private javax.swing.JMenu prochainTransMenu;
    private javax.swing.JButton rateButton;
    private javax.swing.JMenu reportMenu;
    private javax.swing.JMenu restoreMenu;
    private javax.swing.JMenu systemMenu;
    private javax.swing.JMenu tranferMenu;
    private javax.swing.JMenu transactionMenu;
    // End of variables declaration//GEN-END:variables
    
}
