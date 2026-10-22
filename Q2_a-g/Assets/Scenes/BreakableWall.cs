
using UnityEngine;

public class BreakableWall : MonoBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            PowerUpStatus powerUp =
                collision.gameObject.GetComponent<PowerUpStatus>();

            if (powerUp != null && powerUp.isPoweredUp)
            {
                Destroy(gameObject);
            }
        }
    }
}

