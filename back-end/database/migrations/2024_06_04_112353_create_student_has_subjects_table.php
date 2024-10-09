<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('student_has_subjects', function (Blueprint $table) {
            $table->id();
            $table->integer('subject_id');
            $table->foreignId('student_id')->constrained('Students')->cascadeOnDelete();
            $table->boolean('status_subject')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('student_has_subjects');
    }
};
