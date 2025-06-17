/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.flowershop.repository;

/**
 *
 * @author hp
 */
import com.flowershop.model.Flower;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface FlowerRepository extends MongoRepository<Flower, String> {
}