package com.example;

import java.io.Serializable;

public class Order implements Serializable {
    private String item;
    private double price;
    private int urgency;
    
    @Override
    public String toString() {
        return String.format("{item:%s, price:%s, urgency:%s}", item, price, urgency);
    }

    // GETTERS / SETTERS ---------------------------------------------------------------

    public String getItem() {
        return item;
    }
    public void setItem(String item) {
        this.item = item;
    }
    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;
    }
    public int getUrgency() {
        return urgency;
    }
    public void setUrgency(int urgency) {
        this.urgency = urgency;
    }
}
