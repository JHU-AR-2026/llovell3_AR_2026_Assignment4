
using UnityEngine;
using TMPro;

public class CollectibleManager : MonoBehaviour
{
    public static CollectibleManager Instance;

    public GameObject powerUp;
    public int totalCollectibles = 6;
    public TextMeshProUGUI counterText;

    private int collectedCount = 0;

    void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        if (powerUp != null)
        {
            powerUp.SetActive(false);
        }

        UpdateCounter();
    }

    public void CollectibleCollected()
    {
        collectedCount++;

        UpdateCounter();

        if (collectedCount >= totalCollectibles)
        {
            if (powerUp != null)
            {
                powerUp.SetActive(true);
            }
        }
    }

    void UpdateCounter()
    {
        if (counterText != null)
        {
            counterText.text =
                collectedCount + " / " + totalCollectibles;
        }
    }
}

