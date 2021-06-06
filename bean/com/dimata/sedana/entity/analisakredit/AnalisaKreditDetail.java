/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.analisakredit;

import com.dimata.qdep.entity.Entity;

public class AnalisaKreditDetail extends Entity {

	private long analisaKreditMainId = 0;
	private long masterAnalisaKreditId = 0;
	private double nilai = 0;
	private String notes = "";

	public long getAnalisaKreditMainId() {
		return analisaKreditMainId;
	}

	public void setAnalisaKreditMainId(long analisaKreditMainId) {
		this.analisaKreditMainId = analisaKreditMainId;
	}

	public long getMasterAnalisaKreditId() {
		return masterAnalisaKreditId;
	}

	public void setMasterAnalisaKreditId(long masterAnalisaKreditId) {
		this.masterAnalisaKreditId = masterAnalisaKreditId;
	}

	public double getNilai() {
		return nilai;
	}

	public void setNilai(double nilai) {
		this.nilai = nilai;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

}
