<?php

namespace E2E;

class SideBarTest extends TestCase
{
    public function testSideBar()
    {
        $this->loginAndWait();

        // All basic navigation
        foreach (['home', 'users'] as $screen) {
            $this->goto($screen)
                ->waitUntil(function () use ($screen) {
                    return $this->driver->getCurrentURL() === $this->url.'/#!/'.$screen;
                });
        }
    }
}
