using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthbarController : MonoBehaviour
{
     [SerializeField] private Material hBarMaterial;

     private void Start()
     {
          hBarMaterial.enableInstancing = true;
     }

     public void ReduceHealth()
     {
          float hBarValue = hBarMaterial.GetFloat("_Health");
          hBarValue -= 0.15f;
          hBarMaterial.SetFloat("_Health",hBarValue);
     } 
}
