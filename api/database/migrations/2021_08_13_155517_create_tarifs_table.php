<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTarifsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('tarifs', function (Blueprint $table) {
            $table->id();
            $table->string("name");
            $table->integer("price");
            $table->integer("code")->unique();
            $table->foreignId("edit_by");
            $table->foreignId("update_by");
            $table->foreign("edit_by")->references("id")->on("admins");
            $table->foreign("update_by")->references("id")->on("admins");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('tarifs');
    }
}
