package com.example.model;

import java.io.Serializable;
import java.time.LocalDate;

public class Order implements Serializable {
    private String item;
    private double price;
    private int urgency;
    private LocalDate deliveryDate;
    
    @Override
    public String toString() {
        return String.format("{item:%s, price:%s, urgency:%s}", item, price, urgency);
    }

    // GETTERS / SETTERS ---------------------------------------------------------------

    public LocalDate getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(LocalDate deliveryDate) {
        this.deliveryDate = deliveryDate;
    }

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
