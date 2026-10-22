
using UnityEngine;
using TMPro;

public class GoalZone : MonoBehaviour
{
    public TextMeshProUGUI winText;

    void Start()
    {
        if (winText != null)
        {
            winText.gameObject.SetActive(false);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            if (winText != null)
            {
                winText.gameObject.SetActive(true);
            }

            // Hide the player after reaching the goal.
            other.gameObject.SetActive(false);
        }
    }
}

