
using UnityEngine;

public class RotateObject : MonoBehaviour
{
    public float rotationSpeed = 90f;

    void Update()
    {
        // Rotate around the X axis
        transform.Rotate(rotationSpeed * Time.deltaTime, 0f, 0f);
    }
}


