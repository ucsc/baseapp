<?php

namespace E2E;

use Facebook\WebDriver\Remote\RemoteWebElement;

class HomeScreenTest extends TestCase
{
    public function testHomeScreen()
    {
        $this->loginAndGoTo('home');

        // We must see some greetings
        static::assertTrue($this->el('#homeWrapper > h1')->isDisplayed());

        $this->goto('home');

        
    }
}
