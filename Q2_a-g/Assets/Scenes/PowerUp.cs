
using UnityEngine;
using TMPro;

public class PowerUp : MonoBehaviour
{
    public float speedMultiplier = 2f;
    public Color powerUpColor = Color.green;
    public TextMeshProUGUI statusText;

    private bool activated = false;

    void Start()
    {
        if (statusText != null)
        {
            statusText.gameObject.SetActive(false);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player") && !activated)
        {
            PlayerController player =
                other.GetComponent<PlayerController>();

            if (player != null)
            {
                activated = true;

                PowerUpStatus powerUpStatus =
                    other.GetComponent<PowerUpStatus>();

                if (powerUpStatus != null)
                {
                    powerUpStatus.isPoweredUp = true;
                }

                // Increase the player's movement speed.
                player.speed *= speedMultiplier;

                // Change the player's color.
                Renderer playerRenderer =
                    other.GetComponent<Renderer>();

                if (playerRenderer != null)
                {
                    playerRenderer.material.color = powerUpColor;
                }

                // Display the power-up status message.
                if (statusText != null)
                {
                    statusText.text = "Powered Up!";
                    statusText.gameObject.SetActive(true);
                }

                // Hide the capsule after it is collected.
                gameObject.SetActive(false);
            }
        }
    }
}
