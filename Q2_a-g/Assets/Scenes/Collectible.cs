using UnityEngine;

public class Collectible : MonoBehaviour
{
    private bool collected = false;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player") && !collected)
        {
            collected = true;

            CollectibleManager.Instance.CollectibleCollected();

            gameObject.SetActive(false);
        }
    }
}
