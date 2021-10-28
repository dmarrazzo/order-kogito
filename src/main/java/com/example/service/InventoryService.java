package com.example.service;

import javax.enterprise.context.ApplicationScoped;

import com.example.Order;

@ApplicationScoped
public class InventoryService {
    public int checkAvailability(Order order) {
        if (order.getItem().contains("phone")) {
            return 2;
        } else
            return 0;
    }
}
