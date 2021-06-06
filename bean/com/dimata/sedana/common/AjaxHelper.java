/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.common;

/**
 *
 * @author gndiw
 */
public class AjaxHelper {

    /**
     * @return the ajaxKreditRun
     */
    public static boolean isAjaxKreditRun() {
        return ajaxKreditRun;
    }

    /**
     * @param aAjaxKreditRun the ajaxKreditRun to set
     */
    public static void setAjaxKreditRun(boolean aAjaxKreditRun) {
        ajaxKreditRun = aAjaxKreditRun;
    }
    
    private static boolean ajaxKreditRun = false; 
    
}
